
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

o = s:option(ListValue, "en_mode", font_red..bold_on..translate("Select Mode")..bold_off..font_off)
o.description = translate("Select Mode For ClashWRT Work, Try Flush DNS Cache If Network Error")
o:value("redir-host", translate("redir-host"))
o:value("fake-ip", translate("fake-ip"))
o:value("fake-ip-tun", translate("fake-ip-tun"))

o = s:option( Flag, "enable_udp_proxy", font_red..bold_on..translate("Proxy UDP Traffics")..bold_off..font_off)
o.description = translate("The Servers Must Support UDP forwarding")..", "..font_red..bold_on..translate("If Docker is Installed, UDP May Not Forward Normally")..bold_off..font_off
o.default=1

o = s:option(ListValue, "stack_type", translate("Select Stack Type"))
o.description = translate("Select Stack Type For TUN Mode, According To The Running Speed on Your Machine")
o:depends("en_mode", "fake-ip-tun")
o:value("system", translate("System　"))
o:value("gvisor", translate("Gvisor"))
o.default = "system"

o = s:option(ListValue, "proxy_mode", font_red..bold_on..translate("Proxy Mode")..bold_off..font_off)
o.description = translate("Select Proxy Mode, Use Script Mode Could Prevent Proxy BT traffics If Rules Support, eg.lhie1's")
o:value("rule", translate("Rule Proxy Mode"))
o:value("global", translate("Global Proxy Mode"))
o:value("direct", translate("Direct Proxy Mode"))
o:value("script", translate("Script Proxy Mode (Tun Core Only)"))
o.default = "rule"

o = s:option(Flag, "ipv6_enable", font_red..bold_on..translate("Proxy IPv6 Traffic")..bold_off..font_off)
o.description = font_red..bold_on..translate("Disable IPv6 DHCP To Avoid Abnormal Connection If You Do Not Use")..bold_off..font_off
o.default=0

o = s:option(Flag, "china_ip6_route", translate("China IPv6 Route"))
o.description = translate("Bypass The China Network Flows, Improve Performance")
o.default=0
o:depends("ipv6_enable", 1)

o = s:option(Flag, "disable_udp_quic", font_red..bold_on..translate("Disable QUIC")..bold_off..font_off)
o.description = translate("Prevent YouTube and Others To Use QUIC Transmission")..", "..font_red..bold_on..translate("REJECT UDP Traffic On Port 443")..bold_off..font_off
o.default=1

o = s:option(Flag, "enable_rule_proxy", font_red..bold_on..translate("Rule Match Proxy Mode")..bold_off..font_off)
o.description = translate("Only Proxy Rules Match, Prevent BT/P2P Passing")
o.default=0

o = s:option(Flag, "common_ports", font_red..bold_on..translate("Common Ports Proxy Mode")..bold_off..font_off)
o.description = translate("Only Common Ports, Prevent BT/P2P Passing")
o.default=0
o:depends("en_mode", "redir-host")
o:depends("en_mode", "fake-ip")

o = s:option(Flag, "small_flash_memory", translate("Small Flash Memory"))
o.description = translate("Move Core And GEOIP Data File To /tmp/etc/openclash For Small Flash Memory Device")
o.default=0

return m