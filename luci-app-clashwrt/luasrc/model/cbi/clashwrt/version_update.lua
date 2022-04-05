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

local core_path_mode = uci:get("clashwrt", "config", "small_flash_memory")
local dir = "/etc/openclash/config/"
if core_path_mode ~= 1 then
	dir = "/etc/openclash/config/"
else
	dir = "/tmp/etc/openclash/config/"
end

HTTP.setfilehandler(
	function(meta, chunk, eof)
		local fp = HTTP.formvalue("file_type")
		if not fd then
			if not meta then return end

			if fp == "country.mmdb" then
				if meta and chunk then fd = nixio.open(dir .. meta.file, "w") end
			end
			if not fd then
				um.value = translate("upload file error.")
				return
			end
		end
		if chunk and fd then
			fd:write(chunk)
		end
		if eof and fd then
			fd:close()
			fd = nil
		end
	end
)

if HTTP.formvalue("upload") then
	local f = HTTP.formvalue("ulfile")
	if #f <= 0 then
		um.value = translate("No Specify Upload File")
	end
end

return m