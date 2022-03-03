local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"
local fs = require "luci.clashwrt"
local uci = require "luci.model.uci".cursor()
local json = require "luci.jsonc"


font_green = [[<b style=color:green>]]
font_red = [[<b style=color:red>]]
font_off = [[</b>]]
bold_on  = [[<strong>]]
bold_off = [[</strong>]]

m = Map("clashwrt", translate("DNS Settings"))
m.pageaction = false

s = m:section(TypedSection, "clashwrt")
s.anonymous = true

o = s:option(Flag, "enable_redirect_dns", font_red..bold_on..translate("Redirect Local DNS Setting")..bold_off..font_off)
o.description = translate("Set Local DNS Redirect")
o.default=1

o = s:option(Flag, "enable_custom_dns", font_red..bold_on..translate("Custom DNS Setting")..bold_off..font_off)
o.description = font_red..bold_on..translate("Set OpenClash Upstream DNS Resolve Server")..bold_off..font_off
o.default=0

if op_mode == "redir-host" then
o = s:option(Flag, "dns_remote", font_red..bold_on..translate("DNS Remote")..bold_off..font_off)
o.description = font_red..bold_on..translate("Add DNS Remote Support For Redir-Host")..bold_off..font_off
o.default=1
end

o = s:option(Flag, "append_wan_dns", font_red..bold_on..translate("Append Upstream DNS")..bold_off..font_off)
o.description = font_red..bold_on..translate("Append The Upstream Assigned DNS And Gateway IP To The Nameserver")..bold_off..font_off
o.default=1

if op_mode == "fake-ip" then
o = s:option(Flag, "store_fakeip", font_red..bold_on..translate("Persistence Fake-IP")..bold_off..font_off)
o.description = font_red..bold_on..translate("Cache Fake-IP DNS Resolution Records To File, Improve The Response Speed After Startup")..bold_off..font_off
o.default=1
end

o = s:option(Flag, "ipv6_dns", translate("IPv6 DNS Resolve"))
o.description = font_red..bold_on..translate("Enable Clash to Resolve IPv6 DNS Requests")..bold_off..font_off
o.default=0

o = s:option(Flag, "disable_masq_cache", translate("Disable Dnsmasq's DNS Cache"))
o.description = translate("Recommended Enabled For Avoiding Some Connection Errors")..font_red..bold_on..translate("(Maybe Incompatible For Your Firmware)")..bold_off..font_off
o.default=0

if op_mode == "fake-ip" then
o = s:option("dns", Button, translate("Fake-IP-Filter List Update")) 
o.title = translate("Fake-IP-Filter List Update")
o:depends("dns_advanced_setting", "1")
o.inputtitle = translate("Check And Update")
o.inputstyle = "reload"
o.write = function()
  m.uci:set("clashwrt", "config", "enable", 1)
  m.uci:commit("clashwrt")
  SYS.call("rm -rf /tmp/claswrt_fake_filter.list >/dev/null 2>&1 && /etc/init.d/clashwrt restart >/dev/null 2>&1 &")
  HTTP.redirect(DISP.build_url("admin", "services", "clashwrt"))
end

custom_fake_black = s:option("dns", Value, "custom_fake_filter")
custom_fake_black.template = "cbi/tvalue"
custom_fake_black.description = translate("Domain Names In The List Do Not Return Fake-IP, One rule per line")
custom_fake_black.rows = 20
custom_fake_black.wrap = "off"
custom_fake_black:depends("dns_advanced_setting", "1")

function custom_fake_black.cfgvalue(self, section)
	return NXFS.readfile("/etc/clashwrt/custom/clashwrt_custom_fake_filter.list") or ""
end
function custom_fake_black.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		local old_value = NXFS.readfile("/etc/clashwrt/custom/clashwrt_custom_fake_filter.list")
	  if value ~= old_value then
			NXFS.writefile("/etc/clashwrt/custom/clashwrt_custom_fake_filter.list", value)
		end
	end
end
end

o = s:option(Value, "custom_domain_dns_server", translate("Specify DNS Server"))
o.description = translate("Specify DNS Server For List and Server Nodes With Fake-IP Mode, Only One IP Server Address Support")
o.default="114.114.114.114"
o.placeholder = translate("114.114.114.114 or 127.0.0.1#5300")
o:depends("dns_advanced_setting", "1")

custom_domain_dns = s:option(Value, "custom_domain_dns")
custom_domain_dns.template = "cbi/tvalue"
custom_domain_dns.description = translate("Domain Names In The List Use The Custom DNS Server, One rule per line")
custom_domain_dns.rows = 20
custom_domain_dns.wrap = "off"
custom_domain_dns:depends("dns_advanced_setting", "1")

function custom_domain_dns.cfgvalue(self, section)
	return NXFS.readfile("/etc/clashwrt/custom/clashwrt_custom_domain_dns.list") or ""
end
function custom_domain_dns.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		local old_value = NXFS.readfile("/etc/clashwrt/custom/clashwrt_custom_domain_dns.list")
	  if value ~= old_value then
			NXFS.writefile("/etc/clashwrt/custom/clashwrt_custom_domain_dns.list", value)
		end
	end
end

custom_domain_dns_policy = s:option(Value, "custom_domain_dns_core")
custom_domain_dns_policy.template = "cbi/tvalue"
custom_domain_dns_policy.description = translate("Domain Names In The List Use The Custom DNS Server, But Still Return Fake-IP Results, One rule per line")
custom_domain_dns_policy.rows = 20
custom_domain_dns_policy.wrap = "off"
custom_domain_dns_policy:depends("dns_advanced_setting", "1")


function custom_domain_dns_policy.cfgvalue(self, section)
	return NXFS.readfile("/etc/claswrt/custom/clashwrt_custom_domain_dns_policy.list") or ""
end
function custom_domain_dns_policy.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		local old_value = NXFS.readfile("/etc/clashwrt/custom/clashwrt_custom_domain_dns_policy.list")
	  if value ~= old_value then
			NXFS.writefile("/etc/clashwrt/custom/clashwrt_custom_domain_dns_policy.list", value)
		end
	end
end

-- [[ Edit Server ]] --
s = m:section(TypedSection, "dns_servers", translate("Add Custom DNS Servers")..translate("(Take Effect After Choose Above)"))
s.anonymous = true
s.addremove = true
s.sortable = false
s.template = "cbi/tblsection"
s.rmempty = false

---- enable flag
o = s:option(Flag, "enabled", translate("Enable"), font_red..bold_on..translate("(Enable or Disable)")..bold_off..font_off)
o.rmempty     = false
o.default     = o.enabled
o.cfgvalue    = function(...)
    return Flag.cfgvalue(...) or "1"
end

---- group
o = s:option(ListValue, "group", translate("DNS Server Group"))
o.description = font_red..bold_on..translate("(NameServer Group Must Be Set)")..bold_off..font_off
o:value("nameserver", translate("NameServer"))
o:value("fallback", translate("FallBack"))
o.default     = "nameserver"
o.rempty      = false

---- IP address
o = s:option(Value, "ip", translate("DNS Server Address"))
o.description = font_red..bold_on..translate("(Do Not Add Type Ahead)")..bold_off..font_off
o.placeholder = translate("Not Null")
o.datatype = "or(host, string)"
o.rmempty = true

---- port
o = s:option(Value, "port", translate("DNS Server Port"))
o.description = font_red..bold_on..translate("(Require When Use Non-Standard Port)")..bold_off..font_off
o.datatype    = "port"
o.rempty      = true

---- type
o = s:option(ListValue, "type", translate("DNS Server Type"))
o.description = font_red..bold_on..translate("(Communication protocol)")..bold_off..font_off
o:value("udp", translate("UDP"))
o:value("tcp", translate("TCP"))
o:value("tls", translate("TLS"))
o:value("https", translate("HTTPS"))
o.default     = "udp"
o.rempty      = false

return m