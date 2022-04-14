
local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"
local fs = require "luci.clashwrt"
local uci = require "luci.model.uci".cursor()
local json = require "luci.jsonc"

m = Map("clashwrt", translate("Access Control"))
m.pageaction = false

s = m:section(TypedSection, "clashwrt")
-- s.anonymous = true

o = s:option(ListValue, "lan_ac_mode", translate("LAN Access Control Mode"))
o:value("0", translate("Black List Mode"))
o:value("1", translate("White List Mode"))
o.default=0

ip_b = s:option(DynamicList, "lan_ac_black_ips", translate("LAN Bypassed Host List"))
ip_b:depends("lan_ac_mode", "0")
ip_b.datatype = "ipaddr"

mac_b = s:option(DynamicList, "lan_ac_black_macs", translate("LAN Bypassed Mac List"))
mac_b.datatype = "list(macaddr)"
mac_b.rmempty  = true
mac_b:depends("lan_ac_mode", "0")


ip_w = s:option(DynamicList, "lan_ac_white_ips", translate("LAN Proxied Host List"))
ip_w:depends("lan_ac_mode", "1")
ip_w.datatype = "ipaddr"

mac_w = s:option(DynamicList, "lan_ac_white_macs", translate("LAN Proxied Mac List"))
mac_w.datatype = "list(macaddr)"
mac_w.rmempty  = true
mac_w:depends("lan_ac_mode", "1")

luci.ip.neighbors({ family = 4 }, function(n)
	if n.mac and n.dest then
		ip_b:value(n.dest:string())
		ip_w:value(n.dest:string())
		mac_b:value(n.mac, "%s (%s)" %{ n.mac, n.dest:string() })
		mac_w:value(n.mac, "%s (%s)" %{ n.mac, n.dest:string() })
	end
end)

if string.len(SYS.exec("/usr/share/clashwrt/clashwrt_get_network.lua 'gateway6'")) ~= 0 then
    luci.ip.neighbors({ family = 6 }, function(n)
        if n.mac and n.dest then
            ip_b:value(n.dest:string())
            ip_w:value(n.dest:string())
            mac_b:value(n.mac, "%s (%s)" %{ n.mac, n.dest:string() })
            mac_w:value(n.mac, "%s (%s)" %{ n.mac, n.dest:string() })
        end
    end)
end


o = s:option(DynamicList, "wan_ac_black_ips", translate("WAN Bypassed Host List"))
o.datatype = "ipaddr"
o.description = translate("In The Fake-IP Mode, Only Pure IP Requests Are Supported")

local t = {
    {Commit, Apply}
 }
 a = m:section(Table, t)
 o = a:option(Button, "Commit", " ")
 o.inputtitle = translate("Commit Settings")
 o.inputstyle = "apply"
 o.write = function()
  m.uci:commit("clashwrt")
 end
 
 o = a:option(Button, "Apply", " ")
 o.inputtitle = translate("Apply Settings")
 o.inputstyle = "apply"
 o.write = function()
   m.uci:set("clashwrt", "config", "enable", 1)
   m.uci:commit("clashwrt")
   SYS.call("/etc/init.d/clashwrt restart >/dev/null 2>&1 &")
   HTTP.redirect(DISP.build_url("admin", "services", "clashwrt"))
 end
 
return m