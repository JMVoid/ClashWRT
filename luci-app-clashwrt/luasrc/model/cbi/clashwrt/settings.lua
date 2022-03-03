
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

m = Map("clashwrt", translate("Operation Mode"))
m.pageaction = false

s = m:section(TypedSection, "clashwrt")
s.anonymous = true

o = s:option(ListValue, "interface_name", font_red..bold_on..translate("Bind Network Interface")..bold_off..font_off)
local de_int = SYS.exec("ip route |grep 'default' |awk '{print $5}' 2>/dev/null") or SYS.exec("/usr/share/clashwrt/clashwrt_get_network.lua 'dhcp'")
o.description = translate("Default Interface Name:").." "..font_green..bold_on..de_int..bold_off..font_off..translate(",Try Enable If Network Loopback")
local interfaces = SYS.exec("ls -l /sys/class/net/ 2>/dev/null |awk '{print $9}' 2>/dev/null")
for interface in string.gmatch(interfaces, "%S+") do
   o:value(interface)
end
o:value("0", translate("Disable"))
o.default=0

o = s:option(Value, "log_size", translate("Log Size (KB)"))
o.description = translate("Set Log File Size (KB)")
o.default=1024

o = s:option(Value, "dns_port")
o.title = translate("DNS Port")
o.default = 7874
o.datatype = "port"
o.rmempty = false
o.description = translate("Please Make Sure Ports Available")

o = s:option(Value, "proxy_port")
o.title = translate("Redir Port")
o.default = 7892
o.datatype = "port"
o.rmempty = false
o.description = translate("Please Make Sure Ports Available")

o = s:option(Value, "tproxy_port")
o.title = translate("TProxy Port")
o.default = 7895
o.datatype = "port"
o.rmempty = false
o.description = translate("Please Make Sure Ports Available")

o = s:option(Value, "http_port")
o.title = translate("HTTP(S) Port")
o.default = 7890
o.datatype = "port"
o.rmempty = false
o.description = translate("Please Make Sure Ports Available")

o = s:option(Value, "socks_port")
o.title = translate("SOCKS5 Port")
o.default = 7891
o.datatype = "port"
o.rmempty = false
o.description = translate("Please Make Sure Ports Available")

o = s:option(Value, "mixed_port")
o.title = translate("Mixed Port")
o.default = 7893
o.datatype = "port"
o.rmempty = false
o.description = translate("Please Make Sure Ports Available")

return m