local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"
local fs = require "luci.clashwrt"
local uci = require "luci.model.uci".cursor()

m = Map("clashwrt", translate("Version Update"))
m.pageaction = false

sul =m:section(SimpleSection, "")
o = sul:option(FileUpload, "")
o.template = "clashwrt/upload"
um = sul:option(DummyValue, "", nil)
um.template = "clashwrt/dvalue"

s = m:section(TypedSection, "clashwrt")
s.anonymous = true

core_update = s:option(DummyValue, "", nil)
core_update.template = "clashwrt/update"

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