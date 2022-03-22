local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
local UTIL = require "luci.util"
local fs = require "luci.clashwrt"
local uci = require("luci.model.uci").cursor()

m = SimpleForm("clashwrt", translate("ClashWRT"))
m.description = translate("A Clash Client For OpenWrt")
m.reset = false
m.submit = false

m:section(SimpleSection).template = "clashwrt/status"

function default_config_set(f)
	local cf = uci:get("clashwrt", "config", "config_path")
	if cf == "/etc/clashwrt/config/"..f or not cf or cf == "" or not fs.isfile(cf) then
		-- if CHIF == "1" and cf == "/etc/openclash/config/"..f then
		-- 	return
		-- end
		local fis = fs.glob("/etc/clashwrt/config/*")[1]
		if fis ~= nil then
			fcf = fs.basename(fis)
			if fcf then
				uci:set("clashwrt", "config", "config_path", "/etc/clashwrt/config/"..fcf)
				uci:commit("clashwrt")
			end
		else
			uci:set("clashwrt", "config", "config_path", "/etc/clashwrt/config/config.yaml")
			uci:commit("clashwrt")
		end
	end
end

function IsYamlFile(e)
	e=e or""
	local e=string.lower(string.sub(e,-5,-1))
	return e == ".yaml"
end
function IsYmlFile(e)
	e=e or""
	local e=string.lower(string.sub(e,-4,-1))
	return e == ".yml"
end

function config_check(CONFIG_FILE)
	local yaml = fs.isfile(CONFIG_FILE)
	if yaml then
		yaml = SYS.exec(string.format('ruby -ryaml -E UTF-8 -e "puts YAML.load_file(\'%s\')" 2>/dev/null',CONFIG_FILE))
		if yaml ~= "false\n" and yaml ~= "" then
			return "Config Normal"
		else
			return "Config Abnormal"
		end
	elseif (yaml ~= 0) then
		return "File Not Exist"
	end
end


-- section of config files 
local e,a={}
for t,o in ipairs(fs.glob("/etc/clashwrt/config/*"))do
a=fs.stat(o)
if a then
e[t]={}
e[t].name=fs.basename(o)
-- BACKUP_FILE="/etc/openclash/backup/".. e[t].name
-- if fs.mtime(BACKUP_FILE) then
--    e[t].mtime=os.date("%Y-%m-%d %H:%M:%S",fs.mtime(BACKUP_FILE))
-- else
--    e[t].mtime=os.date("%Y-%m-%d %H:%M:%S",a.mtime)
-- end
if uci:get("clashwrt", "config", "config_path") and string.sub(uci:get("clashwrt", "config", "config_path"), 22, -1) == e[t].name then
   e[t].state=translate("Enable")
else
   e[t].state=translate("Disable")
end
e[t].size=fs.filesize(a.size)
e[t].check=translate(config_check(o))
e[t].remove=0
end
end

-- config file list simleform beginning 
form=SimpleForm("config_file_list",translate("Config File List"))
form.reset=false
form.submit=false
tb=form:section(Table,e)
st=tb:option(DummyValue,"state",translate("State"))
st.template="clashwrt/cfg_check"
nm=tb:option(DummyValue,"name",translate("Config Alias"))
mt=tb:option(DummyValue,"mtime",translate("Update Time"))
sz=tb:option(DummyValue,"size",translate("Size"))
ck=tb:option(DummyValue,"check",translate("Grammar Check"))
ck.template="clashwrt/cfg_check"
nm.template="clashwrt/sub_info_show"

btnis=tb:option(Button,"switch",translate("Switch Config"))
btnis.template="clashwrt/other_button"
btnis.render=function(o,t,a)
if not e[t] then return false end
if IsYamlFile(e[t].name) or IsYmlFile(e[t].name) then
a.display=""
else
a.display="none"
end
o.inputstyle="apply"
Button.render(o,t,a)
end
btnis.write=function(a,t)
-- fs.unlink("/tmp/Proxy_Group")
	uci:set("clashwrt", "config", "config_path", "/etc/clashwrt/config/"..e[t].name)
	uci:commit("clashwrt")
	HTTP.redirect(luci.dispatcher.build_url("admin", "services", "clashwrt", "client"))
end

btncp=tb:option(Button,"copy",translate("Copy Config"))
btncp.template="clashwrt/other_button"
btncp.render=function(o,t,a)
if not e[t] then return false end
if IsYamlFile(e[t].name) or IsYmlFile(e[t].name) then
a.display=""
else
a.display="none"
end
o.inputstyle="apply"
Button.render(o,t,a)
end
btncp.write=function(a,t)
	local num = 1
	while true do
		num = num + 1
		if not fs.isfile("/etc/clashwrt/config/"..fs.filename(e[t].name).."("..num..")"..".yaml") then
			fs.copy("/etc/clashwrt/config/"..e[t].name, "/etc/clashwrt/config/"..fs.filename(e[t].name).."("..num..")"..".yaml")
			break
		end
	end
	HTTP.redirect(luci.dispatcher.build_url("admin", "services", "clashwrt", "config"))
end

btndl = tb:option(Button,"download",translate("Download Config"))
btndl.template="clashwrt/other_button"
btndl.render=function(e,t,a)
e.inputstyle="remove"
Button.render(e,t,a)
end
btndl.write = function (a,t)
	local sPath, sFile, fd, block
	sPath = "/etc/clashwrt/config/"..e[t].name
	sFile = NXFS.basename(sPath)
	if fs.isdirectory(sPath) then
		fd = io.popen('tar -C "%s" -cz .' % {sPath}, "r")
		sFile = sFile .. ".tar.gz"
	else
		fd = nixio.open(sPath, "r")
	end
	if not fd then
		return
	end
	HTTP.header('Content-Disposition', 'attachment; filename="%s"' % {sFile})
	HTTP.prepare_content("application/octet-stream")
	while true do
		block = fd:read(nixio.const.buffersize)
		if (not block) or (#block ==0) then
			break
		else
			HTTP.write(block)
		end
	end
	fd:close()
	HTTP.close()
end

btndlr = tb:option(Button,"download_run",translate("Download Running Config"))
btndlr.template="clashwrt/other_button"
btndlr.render=function(c,t,a)
	if nixio.fs.access("/etc/clashwrt/"..e[t].name)  then
		a.display=""
	else
		a.display="none"
	end
c.inputstyle="remove"
Button.render(c,t,a)
end
btndlr.write = function (a,t)
	local sPath, sFile, fd, block
	sPath = "/etc/clashwrt/"..e[t].name
	sFile = NXFS.basename(sPath)
	if fs.isdirectory(sPath) then
		fd = io.popen('tar -C "%s" -cz .' % {sPath}, "r")
		sFile = sFile .. ".tar.gz"
	else
		fd = nixio.open(sPath, "r")
	end
	if not fd then
		return
	end
	HTTP.header('Content-Disposition', 'attachment; filename="%s"' % {sFile})
	HTTP.prepare_content("application/octet-stream")
	while true do
		block = fd:read(nixio.const.buffersize)
		if (not block) or (#block ==0) then
			break
		else
			HTTP.write(block)
		end
	end
	fd:close()
	HTTP.close()
end

btnrm=tb:option(Button,"remove",translate("Remove"))
btnrm.render=function(e,t,a)
e.inputstyle="reset"
Button.render(e,t,a)
end
btnrm.write=function(a,t)
	-- fs.unlink("/tmp/Proxy_Group")
	-- fs.unlink("/etc/clashwrt/backup/"..fs.basename(e[t].name))
	-- fs.unlink("/etc/clashwrt/history/"..fs.filename(e[t].name))
	-- fs.unlink("/etc/clashwrt/history/"..fs.filename(e[t].name)..".db")
	-- fs.unlink("/etc/clashwrt/"..fs.basename(e[t].name))
	local a=fs.unlink("/etc/clashwrt/config/"..fs.basename(e[t].name))
	default_config_set(fs.basename(e[t].name))
	if a then table.remove(e,t)end
	HTTP.redirect(DISP.build_url("admin", "services", "clashwrt","config"))
end

local t = {
    {Commit, Create, Apply}
}

q = form:section(Table, t)

o = q:option(Button, "Commit", " ")
o.inputtitle = translate("Commit Settings")
o.inputstyle = "apply"
o.write = function()
	-- fs.unlink("/tmp/Proxy_Group")
  uci:commit("clashwrt")
end

o = q:option(DummyValue, "Create", " ")
o.rawhtml = true
o.template = "clashwrt/input_file_name"
o.value = "/etc/clashwrt/config/"

o = q:option(Button, "Apply", " ")
o.inputtitle = translate("Apply Settings")
o.inputstyle = "apply"
o.write = function()
	-- fs.unlink("/tmp/Proxy_Group")
  uci:set("clashwrt", "config", "enable", 1)
  uci:commit("clashwrt")
  SYS.call("/etc/init.d/clashwrt restart >/dev/null 2>&1 &")
  HTTP.redirect(DISP.build_url("admin", "services", "clashwrt"))
end

-- end of section config file list



-- begin of ip test section
s = SimpleForm("clashwrt")
s.reset = false
s.submit = false
s:section(SimpleSection).template  = "clashwrt/myip"
-- end of ip test section

-- begin of section start/stop clash instance
local t = {
    {enable, disable}
}

ap = SimpleForm("clashwrt")
ap.reset = false
ap.submit = false

ss = ap:section(Table, t)

o = ss:option(Button, "enable", " ")
o.inputtitle = translate("Start ClashWRT")
o.inputstyle = "apply"
o.write = function()
	uci:set("clashwrt", "config", "enable", 1)
	uci:commit("clashwrt")
	SYS.call("/etc/init.d/clashwrt restart >/dev/null 2>&1 &")
end

o = ss:option(Button, "disable", " ")
o.inputtitle = translate("Stop ClashWRT")
o.inputstyle = "reset"
o.write = function()
	uci:set("clashwrt", "config", "enable", 0)
	uci:commit("clashwrt")
	SYS.call("/etc/init.d/clashwrt stop >/dev/null 2>&1 &")
end

-- end of section start/stop clash instance

-- begin of developer section

d = SimpleForm("clashwrt")
d.title = translate("Credits")
d.reset = false
d.submit = false
d:section(SimpleSection).template  = "clashwrt/developer"

form:append(Template("clashwrt/cfg_file_list"));

return m, form, s, ap, d