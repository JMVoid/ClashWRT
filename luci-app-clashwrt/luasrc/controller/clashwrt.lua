module("luci.controller.clashwrt", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/clashwrt") then
		return
	end

	local page
	
	page = entry({"admin", "services", "clashwrt"}, alias("admin", "services", "clashwrt", "client"), _("ClashWRT"), 50)
	page.dependent = true
	page.acl_depends = { "luci-app-clashwrt" }
	entry({"admin", "services", "clashwrt", "client"},form("clashwrt/client"),_("Overviews"), 20).leaf = true
	entry({"admin", "services", "clashwrt", "status"},call("action_status")).leaf=true
	entry({"admin", "services", "clashwrt", "state"},call("action_state")).leaf=true
	entry({"admin", "services", "clashwrt", "startlog"},call("action_start")).leaf=true

	entry({"admin", "services", "clashwrt", "op_mode"},cbi("clashwrt/op_mode"), _("Operation Mode"), 30).leaf=true
	entry({"admin", "services", "clashwrt", "settings"},cbi("clashwrt/settings"), _("General Settings"), 30).leaf=true
	entry({"admin", "services", "clashwrt", "settings"},cbi("clashwrt/dnsSettings"), _("DNS Settings"), 30).leaf=true

	entry({"admin", "services", "clashwrt", "refresh_log"},call("action_refresh_log"))
	entry({"admin", "services", "clashwrt", "del_log"},call("action_del_log"))
	-- entry({"admin", "services", "clashwrt", "del_start_log"},call("action_del_start_log"))
	-- entry({"admin", "services", "clashwrt", "close_all_connection"},call("action_close_all_connection"))
	-- entry({"admin", "services", "clashwrt", "reload_firewall"},call("action_reload_firewall"))
	-- entry({"admin", "services", "clashwrt", "update_subscribe"},call("action_update_subscribe"))
	-- entry({"admin", "services", "clashwrt", "update_other_rules"},call("action_update_other_rules"))
	-- entry({"admin", "services", "clashwrt", "update_geoip"},call("action_update_geoip"))
	-- entry({"admin", "services", "clashwrt", "currentversion"},call("action_currentversion"))
	-- entry({"admin", "services", "clashwrt", "lastversion"},call("action_lastversion"))
	-- entry({"admin", "services", "clashwrt", "save_corever_branch"},call("action_save_corever_branch"))
	-- entry({"admin", "services", "clashwrt", "update"},call("action_update"))
	-- entry({"admin", "services", "clashwrt", "update_ma"},call("action_update_ma"))
	-- entry({"admin", "services", "clashwrt", "opupdate"},call("action_opupdate"))
	-- entry({"admin", "services", "clashwrt", "coreupdate"},call("action_coreupdate"))
	-- entry({"admin", "services", "clashwrt", "ping"}, call("act_ping"))
	-- entry({"admin", "services", "clashwrt", "download_rule"}, call("action_download_rule"))
	-- entry({"admin", "services", "clashwrt", "download_netflix_domains"}, call("action_download_netflix_domains"))
	-- entry({"admin", "services", "clashwrt", "download_disney_domains"}, call("action_download_disney_domains"))
	-- entry({"admin", "services", "clashwrt", "catch_netflix_domains"}, call("action_catch_netflix_domains"))
	-- entry({"admin", "services", "clashwrt", "write_netflix_domains"}, call("action_write_netflix_domains"))
	-- entry({"admin", "services", "clashwrt", "restore"}, call("action_restore_config"))
	-- entry({"admin", "services", "clashwrt", "backup"}, call("action_backup"))
	-- entry({"admin", "services", "clashwrt", "remove_all_core"}, call("action_remove_all_core"))
	-- entry({"admin", "services", "clashwrt", "one_key_update"}, call("action_one_key_update"))
	entry({"admin", "services", "clashwrt", "one_key_update_check"}, call("action_one_key_update_check"))
	-- entry({"admin", "services", "clashwrt", "switch_mode"}, call("action_switch_mode"))
	-- entry({"admin", "services", "clashwrt", "op_mode"}, call("action_op_mode"))
	-- entry({"admin", "services", "clashwrt", "dler_info"}, call("action_dler_info"))
	-- entry({"admin", "services", "clashwrt", "dler_checkin"}, call("action_dler_checkin"))
	-- entry({"admin", "services", "clashwrt", "dler_logout"}, call("action_dler_logout"))
	-- entry({"admin", "services", "clashwrt", "dler_login"}, call("action_dler_login"))
	-- entry({"admin", "services", "clashwrt", "dler_login_info_save"}, call("action_dler_login_info_save"))
	entry({"admin", "services", "clashwrt", "sub_info_get"}, call("sub_info_get"))
	-- entry({"admin", "services", "clashwrt", "config_name"}, call("action_config_name"))
	-- entry({"admin", "services", "clashwrt", "switch_config"}, call("action_switch_config"))
	entry({"admin", "services", "clashwrt", "toolbar_show"}, call("action_toolbar_show"))
	entry({"admin", "services", "clashwrt", "toolbar_show_sys"}, call("action_toolbar_show_sys"))
	-- entry({"admin", "services", "clashwrt", "diag_connection"}, call("action_diag_connection"))
	-- entry({"admin", "services", "clashwrt", "gen_debug_logs"}, call("action_gen_debug_logs"))
	-- entry({"admin", "services", "clashwrt", "log_level"}, call("action_log_level"))
	-- entry({"admin", "services", "clashwrt", "switch_log"}, call("action_switch_log"))
	entry({"admin", "services", "clashwrt", "rule_mode"}, call("action_rule_mode"))
	entry({"admin", "services", "clashwrt", "switch_rule_mode"}, call("action_switch_rule_mode"))
	entry({"admin", "services", "clashwrt", "switch_run_mode"}, call("action_switch_run_mode"))
	entry({"admin", "services", "clashwrt", "get_run_mode"}, call("action_get_run_mode"))
	-- entry({"admin", "services", "clashwrt", "settings"},cbi("clashwrt/settings"),_("Global Settings"), 30).leaf = true
	-- entry({"admin", "services", "clashwrt", "servers"},cbi("clashwrt/servers"),_("Servers and Groups"), 40).leaf = true
	-- entry({"admin", "services", "clashwrt", "other-rules-edit"},cbi("clashwrt/other-rules-edit"), nil).leaf = true
	-- entry({"admin", "services", "clashwrt", "rule-providers-settings"},cbi("clashwrt/rule-providers-settings"),_("Rule Providers and Groups"), 50).leaf = true
	-- entry({"admin", "services", "clashwrt", "game-rules-manage"},form("clashwrt/game-rules-manage"), nil).leaf = true
	-- entry({"admin", "services", "clashwrt", "rule-providers-manage"},form("clashwrt/rule-providers-manage"), nil).leaf = true
	-- entry({"admin", "services", "clashwrt", "proxy-provider-file-manage"},form("clashwrt/proxy-provider-file-manage"), nil).leaf = true
	-- entry({"admin", "services", "clashwrt", "rule-providers-file-manage"},form("clashwrt/rule-providers-file-manage"), nil).leaf = true
	-- entry({"admin", "services", "clashwrt", "game-rules-file-manage"},form("clashwrt/game-rules-file-manage"), nil).leaf = true
	-- entry({"admin", "services", "clashwrt", "config-subscribe"},cbi("clashwrt/config-subscribe"),_("Config Update"), 60).leaf = true
	-- entry({"admin", "services", "clashwrt", "config-subscribe-edit"},cbi("clashwrt/config-subscribe-edit"), nil).leaf = true
	-- entry({"admin", "services", "clashwrt", "servers-config"},cbi("clashwrt/servers-config"), nil).leaf = true
	-- entry({"admin", "services", "clashwrt", "groups-config"},cbi("clashwrt/groups-config"), nil).leaf = true
	-- entry({"admin", "services", "clashwrt", "proxy-provider-config"},cbi("clashwrt/proxy-provider-config"), nil).leaf = true
	-- entry({"admin", "services", "clashwrt", "rule-providers-config"},cbi("clashwrt/rule-providers-config"), nil).leaf = true
	-- entry({"admin", "services", "clashwrt", "config"},form("clashwrt/config"),_("Config Manage"), 70).leaf = true
	entry({"admin", "services", "clashwrt", "log"},cbi("clashwrt/log"),_("Server Logs"), 80).leaf = true

end
local fs = require "luci.clashwrt"
local json = require "luci.jsonc"
local uci = require("luci.model.uci").cursor()
local datatype = require "luci.cbi.datatypes"

local core_path_mode = uci:get("clashwrt", "config", "small_flash_memory")
if core_path_mode ~= "1" then
	dev_core_path="/etc/clashwrt/core/clash"
	tun_core_path="/etc/clashwrt/core/clash_tun"
else
	dev_core_path="/tmp/etc/clashwrt/core/clash"
	tun_core_path="/tmp/etc/clashwrt/core/clash_tun"
end

local function is_running()
	return luci.sys.call("pidof clash >/dev/null") == 0
end

local function is_web()
	return luci.sys.call("pidof clash >/dev/null") == 0
end

local function restricted_mode()
	return uci:get("clashwrt", "config", "restricted_mode")
end

local function is_watchdog()
	local ps_version = luci.sys.exec("ps --version 2>&1 |grep -c procps-ng |tr -d '\n'")
	if ps_version == "1" then
		return luci.sys.call("ps -efw |grep clashwrt_watchdog.sh |grep -v grep >/dev/null") == 0
	else
		return luci.sys.call("ps -w |grep clashwrt_watchdog.sh |grep -v grep >/dev/null") == 0
	end
end

local function cn_port()
	return uci:get("clashwrt", "config", "cn_port")
end

local function mode()
	return uci:get("clashwrt", "config", "en_mode")
end

local function ipdb()
	return os.date("%Y-%m-%d %H:%M:%S",fs.mtime("/etc/clashwrt/Country.mmdb"))
end

local function lhie1()
	return os.date("%Y-%m-%d %H:%M:%S",fs.mtime("/usr/share/clashwrt/res/lhie1.yaml"))
end

local function ConnersHua()
	return os.date("%Y-%m-%d %H:%M:%S",fs.mtime("/usr/share/clashwrt/res/ConnersHua.yaml"))
end

local function ConnersHua_return()
	return os.date("%Y-%m-%d %H:%M:%S",fs.mtime("/usr/share/clashwrt/res/ConnersHua_return.yaml"))
end

local function chnroute()
	return os.date("%Y-%m-%d %H:%M:%S",fs.mtime("/etc/clashwrt/rule_provider/ChinaIP.yaml"))
end

local function daip()
	local daip = luci.sys.exec("uci -q get network.lan.ipaddr |awk -F '/' '{print $1}' 2>/dev/null |tr -d '\n'")
	if not daip or daip == "" then
		local daip = luci.sys.exec("ip addr show 2>/dev/null | grep -w 'inet' | grep 'global' | grep 'brd' | grep -Eo 'inet [0-9\.]+' | awk '{print $2}' | head -n 1 | tr -d '\n'")
	end
	return daip
end

local function dase()
	return uci:get("clashwrt", "config", "dashboard_password")
end

local function db_foward_domain()
	return uci:get("clashwrt", "config", "dashboard_forward_domain")
end

local function db_foward_port()
	return uci:get("clashwrt", "config", "dashboard_forward_port")
end

local function check_lastversion()
	luci.sys.exec("sh /usr/share/clashwrt/clashwrt_version.sh 2>/dev/null")
	return luci.sys.exec("sed -n '/^https:/,$p' /tmp/clashwrt_last_version 2>/dev/null")
end

local function check_currentversion()
	return luci.sys.exec("sed -n '/^data:image/,$p' /usr/share/clashwrt/res/clashwrt_version 2>/dev/null")
end

local function startlog()
	local info = ""
	local line_trans = ""
	if nixio.fs.access("/tmp/clashwrt_start.log") then
		info = luci.sys.exec("sed -n '$p' /tmp/clashwrt_start.log 2>/dev/null")
		line_trans = info
		if string.len(info) > 0 then
			if not string.find (info, "【") and not string.find (info, "】") then
   			line_trans = luci.i18n.translate(string.sub(info, 0, -1))
   		else
   			local no_trans = {}
   			line_trans = ""
   			local a = string.find (info, "【")
   			local b = string.find (info, "】") + 2
   			local c = 0
   			local v
   			local x
   			while true do
   				table.insert(no_trans, a)
   				table.insert(no_trans, b)
   				if string.find (info, "【", b+1) and string.find (info, "】", b+1) then
   					a = string.find (info, "【", b+1)
   					b = string.find (info, "】", b+1) + 2
   				else
   					break
   				end
   			end
   			for k = 1, #no_trans, 2 do
   				x = no_trans[k]
   				v = no_trans[k+1]
   				if x <= 1 then
   					line_trans = line_trans .. string.sub(info, 0, v)
   				elseif v <= string.len(info) then
   					line_trans = line_trans .. luci.i18n.translate(string.sub(info, c, x - 1))..string.sub(info, x, v)
   				end
   				c = v + 1
   			end
   			if c > string.len(info) then
   				line_trans = line_trans
   			else
   				line_trans = line_trans .. luci.i18n.translate(string.sub(info, c, -1))
   			end
   		end
   	end
	end
	return line_trans
end

local function coremodel()
  local coremodel = luci.sys.exec("opkg status libc 2>/dev/null |grep 'Architecture' |awk -F ': ' '{print $2}' 2>/dev/null")
  return coremodel
end

local function corecv()
if not nixio.fs.access(dev_core_path) then
  return "0"
else
	return luci.sys.exec(string.format("%s -v 2>/dev/null |awk -F ' ' '{print $2}'",dev_core_path))
end
end

local function coretuncv()
if not nixio.fs.access(tun_core_path) then
  return "0"
else
	return luci.sys.exec(string.format("%s -v 2>/dev/null |awk -F ' ' '{print $2}'",tun_core_path))
end
end

local function corelv()
	luci.sys.call("sh /usr/share/clashwrt/clash_version.sh")
	local core_lv = luci.sys.exec("sed -n 1p /tmp/clash_last_version 2>/dev/null")
	local core_tun_lv = luci.sys.exec("sed -n 2p /tmp/clash_last_version 2>/dev/null")
	return core_lv .. "," .. core_tun_lv
end

local function opcv()
	return luci.sys.exec("sed -n 1p /usr/share/clashwrt/res/clashwrt_version 2>/dev/null")
end

local function oplv()
	 local new = luci.sys.call(string.format("sh /usr/share/clashwrt/clashwrt_version.sh"))
	 local oplv = luci.sys.exec("sed -n 1p /tmp/clashwrt_last_version 2>/dev/null")
   return oplv .. "," .. new
end

local function opup()
   luci.sys.call("rm -rf /tmp/*_last_version 2>/dev/null && sh /usr/share/clashwrt/clashwrt_version.sh >/dev/null 2>&1")
   return luci.sys.call("sh /usr/share/clashwrt/clashwrt_update.sh >/dev/null 2>&1 &")
end

local function coreup()
	uci:set("clashwrt", "config", "enable", "1")
	uci:commit("clashwrt")
	local type = luci.http.formvalue("core_type")
	luci.sys.call("rm -rf /tmp/*_last_version 2>/dev/null && sh /usr/share/clashwrt/clash_version.sh >/dev/null 2>&1")
	return luci.sys.call(string.format("/usr/share/clashwrt/clashwrt_core.sh '%s' >/dev/null 2>&1 &", type))
end

local function corever()
	return uci:get("clashwrt", "config", "core_version")
end

local function release_branch()
	return uci:get("clashwrt", "config", "release_branch")
end

local function save_corever_branch()
	if luci.http.formvalue("core_ver") then
		uci:set("clashwrt", "config", "core_version", luci.http.formvalue("core_ver"))
	end
	if luci.http.formvalue("release_branch") then
		uci:set("clashwrt", "config", "release_branch", luci.http.formvalue("release_branch"))
	end
	uci:commit("clashwrt")
	return "success"
end

local function upchecktime()
   local corecheck = os.date("%Y-%m-%d %H:%M:%S",fs.mtime("/tmp/clash_last_version"))
   local opcheck
   if not corecheck or corecheck == "" then
      opcheck = os.date("%Y-%m-%d %H:%M:%S",fs.mtime("/tmp/clashwrt_last_version"))
      if not opcheck or opcheck == "" then
         return "1"
      else
         return opcheck
      end
   else
      return corecheck
   end
end

local function historychecktime()
	local CONFIG_FILE = uci:get("clashwrt", "config", "config_path")
	if not CONFIG_FILE then return "0" end
  local HISTORY_PATH_OLD = "/etc/clashwrt/history/" .. fs.filename(fs.basename(CONFIG_FILE))
  local HISTORY_PATH = "/etc/clashwrt/history/" .. fs.filename(fs.basename(CONFIG_FILE)) .. ".db"
	if not nixio.fs.access(HISTORY_PATH) and not nixio.fs.access(HISTORY_PATH_OLD) then
  	return "0"
	else
		return os.date("%Y-%m-%d %H:%M:%S",fs.mtime(HISTORY_PATH)) or os.date("%Y-%m-%d %H:%M:%S",fs.mtime(HISTORY_PATH_OLD))
	end
end

function download_rule()
	local filename = luci.http.formvalue("filename")
  local state = luci.sys.call(string.format('/usr/share/clashwrt/clashwrt_download_rule_list.sh "%s" >/dev/null 2>&1',filename))
  return state
end

function download_disney_domains()
  local state = luci.sys.call(string.format('/usr/share/clashwrt/clashwrt_download_rule_list.sh "%s" >/dev/null 2>&1',"disney_domains"))
  return state
end

function download_netflix_domains()
  local state = luci.sys.call(string.format('/usr/share/clashwrt/clashwrt_download_rule_list.sh "%s" >/dev/null 2>&1',"netflix_domains"))
  return state
end

function action_restore_config()
	uci:set("clashwrt", "config", "enable", "0")
	uci:commit("clashwrt")
	luci.sys.call("/etc/init.d/clashwrt stop >/dev/null 2>&1")
	luci.sys.call("cp '/usr/share/clashwrt/backup/clashwrt' '/etc/config/clashwrt' >/dev/null 2>&1 &")
	luci.sys.call("cp /usr/share/clashwrt/backup/clashwrt_custom* /etc/clashwrt/custom/ >/dev/null 2>&1 &")
	luci.http.redirect(luci.dispatcher.build_url('admin/services/clashwrt/settings'))
end

function action_remove_all_core()
	luci.sys.call("rm -rf /etc/clashwrt/core/* >/dev/null 2>&1")
end

function action_one_key_update()
  return luci.sys.call("sh /usr/share/clashwrt/clashwrt_update.sh 'one_key_update' >/dev/null 2>&1 &")
end

local function dler_login_info_save()
	uci:set("clashwrt", "config", "dler_email", luci.http.formvalue("email"))
	uci:set("clashwrt", "config", "dler_passwd", luci.http.formvalue("passwd"))
	uci:set("clashwrt", "config", "dler_checkin", luci.http.formvalue("checkin"))
	uci:set("clashwrt", "config", "dler_checkin_interval", luci.http.formvalue("interval"))
	if tonumber(luci.http.formvalue("multiple")) > 50 then
		uci:set("clashwrt", "config", "dler_checkin_multiple", "50")
	elseif tonumber(luci.http.formvalue("multiple")) < 1 or not tonumber(luci.http.formvalue("multiple")) then
		uci:set("clashwrt", "config", "dler_checkin_multiple", "1")
	else
		uci:set("clashwrt", "config", "dler_checkin_multiple", luci.http.formvalue("multiple"))
	end
	uci:commit("clashwrt")
	return "success"
end

local function dler_login()
	local info, token, get_sub, sub_info, sub_key, sub_match
	local sub_path = "/tmp/dler_sub"
	local email = uci:get("clashwrt", "config", "dler_email")
	local passwd = uci:get("clashwrt", "config", "dler_passwd")
	if email and passwd then
		info = luci.sys.exec(string.format("curl -sL -H 'Content-Type: application/json' -d '{\"email\":\"%s\", \"passwd\":\"%s\"}' -X POST https://dler.cloud/api/v1/login", email, passwd))
		if info then
			info = json.parse(info)
		end
		if info and info.ret == 200 then
			token = info.data.token
			uci:set("clashwrt", "config", "dler_token", token)
			uci:commit("clashwrt")
			get_sub = string.format("curl -sL -H 'Content-Type: application/json' -d '{\"access_token\":\"%s\"}' -X POST https://dler.cloud/api/v1/managed/clash -o %s", token, sub_path)
			luci.sys.exec(get_sub)
			sub_info = fs.readfile(sub_path)
			if sub_info then
				sub_info = json.parse(sub_info)
			end
			if sub_info and sub_info.ret == 200 then
				sub_key = {"smart","ss","vmess","trojan"}
				for _,v in ipairs(sub_key) do
					while true do
						sub_match = false
						uci:foreach("clashwrt", "config_subscribe",
						function(s)
							if s.name == "Dler Cloud - " .. v and s.address == sub_info[v] then
			   				sub_match = true
							end
						end)
						if sub_match then break end
						luci.sys.exec(string.format('sid=$(uci -q add clashwrt config_subscribe) && uci -q set clashwrt."$sid".name="Dler Cloud - %s" && uci -q set clashwrt."$sid".address="%s"', v, sub_info[v]))
						uci:commit("clashwrt")
						break
					end
					luci.sys.exec(string.format('curl -sL -m 3 --retry 2 --user-agent "clash" "%s" -o "/etc/clashwrt/config/Dler Cloud - %s.yaml" >/dev/null 2>&1', sub_info[v], v))
				end
			end
			return info.ret
		else
			uci:delete("clashwrt", "config", "dler_token")
			uci:commit("clashwrt")
			fs.unlink(sub_path)
			fs.unlink("/tmp/dler_checkin")
			fs.unlink("/tmp/dler_info")
			return "402"
		end
	else
		uci:delete("clashwrt", "config", "dler_token")
		uci:commit("clashwrt")
		fs.unlink(sub_path)
		fs.unlink("/tmp/dler_checkin")
		fs.unlink("/tmp/dler_info")
		return "402"
	end
end

local function dler_logout()
	local info, token
	local token = uci:get("clashwrt", "config", "dler_token")
	if token then
		info = luci.sys.exec(string.format("curl -sL -H 'Content-Type: application/json' -d '{\"access_token\":\"%s\"}' -X POST https://dler.cloud/api/v1/logout", token))
		if info then
			info = json.parse(info)
		end
		if info and info.ret == 200 then
			uci:delete("clashwrt", "config", "dler_token")
			uci:delete("clashwrt", "config", "dler_checkin")
			uci:delete("clashwrt", "config", "dler_checkin_interval")
			uci:delete("clashwrt", "config", "dler_checkin_multiple")
			uci:commit("clashwrt")
			fs.unlink("/tmp/dler_sub")
			fs.unlink("/tmp/dler_checkin")
			fs.unlink("/tmp/dler_info")
			return info.ret
		else
			return "403"
		end
	else
		return "403"
	end
end

local function dler_info()
	local info, path, get_info
	local token = uci:get("clashwrt", "config", "dler_token")
	local email = uci:get("clashwrt", "config", "dler_email")
	local passwd = uci:get("clashwrt", "config", "dler_passwd")
	path = "/tmp/dler_info"
	if token and email and passwd then
		get_info = string.format("curl -sL -H 'Content-Type: application/json' -d '{\"email\":\"%s\", \"passwd\":\"%s\"}' -X POST https://dler.cloud/api/v1/information -o %s", email, passwd, path)
		if not nixio.fs.access(path) then
			luci.sys.exec(get_info)
		else
			if fs.readfile(path) == "" or not fs.readfile(path) then
				luci.sys.exec(get_info)
			else
				if (os.time() - fs.mtime(path) > 900) then
					luci.sys.exec(get_info)
				end
			end
		end
		info = fs.readfile(path)
		if info then
			info = json.parse(info)
		end
		if info and info.ret == 200 then
			return info.data
		else
			fs.unlink(path)
			luci.sys.exec(string.format("echo -e %s Dler Cloud Account Login Failed! Please Check And Try Again... >> /tmp/clashwrt.log", os.date("%Y-%m-%d %H:%M:%S")))
			return "error"
		end
	else
		return "error"
	end
end

local function dler_checkin()
	local info
	local path = "/tmp/dler_checkin"
	local token = uci:get("clashwrt", "config", "dler_token")
	local email = uci:get("clashwrt", "config", "dler_email")
	local passwd = uci:get("clashwrt", "config", "dler_passwd")
	local multiple = uci:get("clashwrt", "config", "dler_checkin_multiple") or 1
	if token and email and passwd then
		info = luci.sys.exec(string.format("curl -sL -H 'Content-Type: application/json' -d '{\"email\":\"%s\", \"passwd\":\"%s\", \"multiple\":\"%s\"}' -X POST https://dler.cloud/api/v1/checkin", email, passwd, multiple))
		if info then
			info = json.parse(info)
		end
		if info and info.ret == 200 then
			fs.unlink("/tmp/dler_info")
			fs.writefile(path, info)
			luci.sys.exec(string.format("echo -e %s Dler Cloud Checkin Successful, Result:【%s】 >> /tmp/clashwrt.log", os.date("%Y-%m-%d %H:%M:%S"), info.data.checkin))
			return info
		else
			if info and info.msg then
				luci.sys.exec(string.format("echo -e %s Dler Cloud Checkin Failed, Result:【%s】 >> /tmp/clashwrt.log", os.date("%Y-%m-%d %H:%M:%S"), info.msg))
			else
				luci.sys.exec(string.format("echo -e %s Dler Cloud Checkin Failed! Please Check And Try Again... >> /tmp/clashwrt.log",os.date("%Y-%m-%d %H:%M:%S")))
			end
			return info
		end
	else
		return "error"
	end
end

local function config_name()
	local e,a={}
	for t,o in ipairs(fs.glob("/etc/clashwrt/config/*"))do
		a=fs.stat(o)
		if a then
			e[t]={}
			e[t].name=fs.basename(o)
		end
	end
	return json.parse(json.stringify(e)) or e
end

local function config_path()
	if uci:get("clashwrt", "config", "config_path") then
		return string.sub(uci:get("clashwrt", "config", "config_path"), 23, -1)
	else
		 return ""
	end
end

function action_switch_config()
	uci:set("clashwrt", "config", "config_path", "/etc/clashwrt/config/"..luci.http.formvalue("config_name"))
	uci:commit("clashwrt")
end

function sub_info_get()
	local filename, sub_url, sub_info, info, upload, download, total, expire, http_code
	filename = luci.http.formvalue("filename")
	sub_info = ""
	if filename then
		uci:foreach("clashwrt", "config_subscribe",
			function(s)
				if s.name == filename and s.address then
			  	sub_url = s.address
			  	info = luci.sys.exec(string.format("curl -sLI -m 10 -w 'http_code='%%{http_code} -H 'User-Agent: Clash' '%s'", sub_url))
			  	if info then
			  		http_code=string.sub(string.match(info, "http_code=%d+"), 11, -1)
			  		if tonumber(http_code) == 200 then
			  			info = string.lower(info)
			  			if string.find(info, "subscription%-userinfo") then
			  				info = luci.sys.exec("echo '%s' |grep 'subscription-userinfo'" %info)
			  				upload = string.sub(string.match(info, "upload=%d+"), 8, -1) or nil
			  				download = string.sub(string.match(info, "download=%d+"), 10, -1) or nil
			  				total = fs.filesize(string.sub(string.match(info, "total=%d+"), 7, -1)) or nil
			  				expire = os.date("%Y-%m-%d %H:%M:%S", string.sub(string.match(info, "expire=%d+"), 8, -1)) or nil
			  				used = fs.filesize(upload + download) or nil
			  				sub_info = "Successful"
			  			else
			  				sub_info = "No Sub Info Found"
			  			end
			  		end
			  	end
				end
			end
		)
		if not sub_url then
			sub_info = "No Sub Info Found"
		end
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		http_code = http_code,
		sub_info = sub_info,
		used = used,
		total = total,
		expire = expire;
	})
end

function action_rule_mode()
	local mode, info
	if is_running() then
		local daip = daip()
		local dase = dase() or ""
		local cn_port = cn_port()
		if not daip or not cn_port then return end
		info = json.parse(luci.sys.exec(string.format('curl -sL -m 3 -H "Content-Type: application/json" -H "Authorization: Bearer %s" -XGET http://"%s":"%s"/configs', dase, daip, cn_port)))
		if info then
			mode = info["mode"]
		else
			mode = uci:get("clashwrt", "config", "proxy_mode") or "rule"
		end
	else
		mode = uci:get("clashwrt", "config", "proxy_mode") or "rule"
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		mode = mode;
	})
end

function action_switch_rule_mode()
	local mode, info
	if is_running() then
		local daip = daip()
		local dase = dase() or ""
		local cn_port = cn_port()
		mode = luci.http.formvalue("rule_mode")
		if not daip or not cn_port then luci.http.status(500, "Switch Faild") return end
		info = luci.sys.exec(string.format('curl -sL -m 3 -H "Content-Type: application/json" -H "Authorization: Bearer %s" -XPATCH http://"%s":"%s"/configs -d \'{\"mode\": \"%s\"}\'', dase, daip, cn_port, mode))
		if info ~= "" then
			luci.http.status(500, "Switch Faild")
		end
	else
		luci.http.status(500, "Switch Faild")
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		info = info;
	})
end

function action_get_run_mode()
	if mode() then
		luci.http.prepare_content("application/json")
		luci.http.write_json({
			clash = is_running(),
			mode = mode();
		})
	else
		luci.http.status(500, "Get Faild")
		return
	end
end

function action_switch_run_mode()
	local mode, operation_mode
	if is_running() then
		mode = luci.http.formvalue("run_mode")
		operation_mode = uci:get("clashwrt", "config", "operation_mode")
		if operation_mode == "redir-host" then
			uci:set("clashwrt", "config", "en_mode", "redir-host"..mode)
		elseif operation_mode == "fake-ip" then
			uci:set("clashwrt", "config", "en_mode", "fake-ip"..mode)
		end
		uci:commit("clashwrt")
		luci.sys.exec("/etc/init.d/clashwrt restart >/dev/null 2>&1 &")
	else
		luci.http.status(500, "Switch Faild")
		return
	end
end

function action_log_level()
	local level, info
	if is_running() then
		local daip = daip()
		local dase = dase() or ""
		local cn_port = cn_port()
		if not daip or not cn_port then return end
		info = json.parse(luci.sys.exec(string.format('curl -sL -m 3 -H "Content-Type: application/json" -H "Authorization: Bearer %s" -XGET http://"%s":"%s"/configs', dase, daip, cn_port)))
		if info then
			level = info["log-level"]
		else
			level = uci:get("clashwrt", "config", "log_level") or "info"
		end
	else
		level = uci:get("clashwrt", "config", "log_level") or "info"
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		log_level = level;
	})
end

function action_switch_log()
	local level, info
	if is_running() then
		local daip = daip()
		local dase = dase() or ""
		local cn_port = cn_port()
		level = luci.http.formvalue("log_level")
		if not daip or not cn_port then luci.http.status(500, "Switch Faild") return end
		info = luci.sys.exec(string.format('curl -sL -m 3 -H "Content-Type: application/json" -H "Authorization: Bearer %s" -XPATCH http://"%s":"%s"/configs -d \'{\"log-level\": \"%s\"}\'', dase, daip, cn_port, level))
		if info ~= "" then
			luci.http.status(500, "Switch Faild")
		end
	else
		luci.http.status(500, "Switch Faild")
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		info = info;
	})
end

local function s(e)
local t=0
local a={' B/S',' KB/S',' MB/S',' GB/S',' TB/S'}
if (e<=1024) then
	return e..a[1]
else
repeat
e=e/1024
t=t+1
until(e<=1024)
return string.format("%.1f",e)..a[t]
end
end

function action_toolbar_show_sys()
	local pid = luci.sys.exec("pidof clash |head -1 |tr -d '\n' 2>/dev/null")
	local mem, cpu
	if pid and pid ~= "" then
		mem = tonumber(luci.sys.exec(string.format("cat /proc/%s/status 2>/dev/null |grep -w VmRSS |awk '{print $2}'", pid)))
		cpu = luci.sys.exec(string.format("top -b -n1 |grep -E '%s' 2>/dev/null |grep -v grep |awk '{for (i=1;i<=NF;i++) {if ($i ~ /clash/) break; else cpu=i}}; {print $cpu}' 2>/dev/null", pid))
		if mem and cpu then
			mem = fs.filesize(mem*1024)
			cpu = string.match(cpu, "%d+")
		else
			mem = "0 KB"
			cpu = "0"
		end
	else
		return
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		mem = mem,
		cpu = cpu;
	})
end

function action_toolbar_show()
	local pid = luci.sys.exec("pidof clash |head -1 |tr -d '\n' 2>/dev/null")
	local traffic, connections, connection, up, down, up_total, down_total, mem, cpu
	if pid and pid ~= "" then
		local daip = daip()
		local dase = dase() or ""
		local cn_port = cn_port()
		if not daip or not cn_port then return end
		traffic = json.parse(luci.sys.exec(string.format('curl -sL -m 3 -H "Content-Type: application/json" -H "Authorization: Bearer %s" -XGET http://"%s":"%s"/traffic', dase, daip, cn_port)))
		connections = json.parse(luci.sys.exec(string.format('curl -sL -m 3 -H "Content-Type: application/json" -H "Authorization: Bearer %s" -XGET http://"%s":"%s"/connections', dase, daip, cn_port)))
		if traffic and connections then
			connection = #(connections.connections)
			up = s(traffic.up)
			down = s(traffic.down)
			up_total = fs.filesize(connections.uploadTotal)
			down_total = fs.filesize(connections.downloadTotal)
		else
			up = "0 B/S"
			down = "0 B/S"
			up_total = "0 KB"
			down_total = "0 KB"
			connection = "0"
		end
		mem = tonumber(luci.sys.exec(string.format("cat /proc/%s/status 2>/dev/null |grep -w VmRSS |awk '{print $2}'", pid)))
		cpu = luci.sys.exec(string.format("top -b -n1 |grep -E '%s' 2>/dev/null |grep -v grep |awk '{for (i=1;i<=NF;i++) {if ($i ~ /clash/) break; else cpu=i}}; {print $cpu}' 2>/dev/null", pid))
		if mem and cpu then
			mem = fs.filesize(mem*1024)
			cpu = string.match(cpu, "%d+")
		else
			mem = "0 KB"
			cpu = "0"
		end
	else
		return
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		connections = connection,
		up = up,
		down = down,
		up_total = up_total,
		down_total = down_total,
		mem = mem,
		cpu = cpu;
	})
end

function action_config_name()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		config_name = config_name(),
		config_path = config_path();
	})
end

function action_save_corever_branch()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		save_corever_branch = save_corever_branch();
	})
end

function action_dler_login_info_save()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		dler_login_info_save = dler_login_info_save();
	})
end

function action_dler_info()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		dler_info = dler_info();
	})
end

function action_dler_checkin()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		dler_checkin = dler_checkin();
	})
end

function action_dler_logout()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		dler_logout = dler_logout();
	})
end

function action_dler_login()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		dler_login = dler_login();
	})
end

function action_one_key_update_check()
	luci.sys.call("rm -rf /tmp/*_last_version 2>/dev/null")
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		corever = corever(),
		corelv = corelv(),
		oplv = oplv();
	})
end

function action_op_mode()
	local op_mode = uci:get("clashwrt", "config", "operation_mode")
	luci.http.prepare_content("application/json")
	luci.http.write_json({
	  op_mode = op_mode;
	})
end

function action_switch_mode()
	local switch_mode = uci:get("clashwrt", "config", "operation_mode")
	if switch_mode == "redir-host" then
		uci:set("clashwrt", "config", "operation_mode", "fake-ip")
		uci:commit("clashwrt")
	else
		uci:set("clashwrt", "config", "operation_mode", "redir-host")
		uci:commit("clashwrt")
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({
	  switch_mode = switch_mode;
	})
end

function action_status()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
	  clash = is_running(),
		watchdog = is_watchdog(),
		daip = daip(),
		dase = dase(),
		db_foward_port = db_foward_port(),
		db_foward_domain = db_foward_domain(),
		web = is_web(),
		cn_port = cn_port(),
		restricted_mode = restricted_mode();
	})
end

function action_state()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		lhie1 = lhie1(),
		ConnersHua = ConnersHua(),
		ConnersHua_return = ConnersHua_return(),
		ipdb = ipdb(),
		historychecktime = historychecktime(),
		chnroute = chnroute();
	})
end

function action_lastversion()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
			lastversion = check_lastversion();
	})
end

function action_currentversion()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
			currentversion = check_currentversion();
	})
end

function action_start()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
			startlog = startlog();
	})
end

function action_update()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
			coremodel = coremodel(),
			corecv = corecv(),
			coretuncv = coretuncv(),
			opcv = opcv(),
			corever = corever(),
			release_branch = release_branch(),
			upchecktime = upchecktime(),
			corelv = corelv(),
			oplv = oplv();
	})
end

function action_update_ma()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
			oplv = oplv(),
			corelv = corelv(),
			corever = corever();
	})
end

function action_opupdate()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
			opup = opup();
	})
end

function action_coreupdate()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
			coreup = coreup();
	})
end

function action_close_all_connection()
	return luci.sys.call("sh /usr/share/clashwrt/clashwrt_history_get.sh 'close_all_conection'")
end

function action_reload_firewall()
	return luci.sys.call("/etc/init.d/clashwrt reload")
end

function action_update_subscribe()
	fs.unlink("/tmp/Proxy_Group")
	return luci.sys.call("/usr/share/clashwrt/clashwrt.sh >/dev/null 2>&1")
end

function action_update_other_rules()
	return luci.sys.call("/usr/share/clashwrt/clashwrt_rule.sh >/dev/null 2>&1")
end

function action_update_geoip()
	return luci.sys.call("/usr/share/clashwrt/clashwrt_ipdb.sh >/dev/null 2>&1")
end

function act_ping()
	local e={}
	e.index=luci.http.formvalue("index")
	e.ping=luci.sys.exec("ping -c 1 -W 1 %q 2>&1 | grep -o 'time=[0-9]*.[0-9]' | awk -F '=' '{print$2}'"%luci.http.formvalue("domain"))
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

function action_download_rule()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		rule_download_status = download_rule();
	})
end

function action_download_netflix_domains()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		rule_download_status = download_netflix_domains();
	})
end

function action_download_disney_domains()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		rule_download_status = download_disney_domains();
	})
end

function action_refresh_log()
	luci.http.prepare_content("application/json")
	local logfile="/tmp/clashwrt.log"
	local file = io.open(logfile, "r+")
	local info, len, line, lens, cache, ex_match, line_trans
	local data = ""
	local limit = 1000
	local log_tb = {}
	local log_len = tonumber(luci.http.formvalue("log_len")) or 0
	if file == nil then
 		return nil
 	end
 	file:seek("set")
 	info = file:read("*all")
 	info = info:reverse()
 	file:close()
 	cache, len = string.gsub(info, '[^\n]+', "")
 	if len == log_len then return nil end
	if log_len == 0 then
		if len > limit then lens = limit else lens = len end
	else
		lens = len - log_len
	end
	string.gsub(info, '[^\n]+', function(w) table.insert(log_tb, w) end, lens)
	for i=1, lens do
		line = log_tb[i]:reverse()
		line_trans = line
		ex_match = false
		while true do
			ex_keys = {"^Sec%-Fetch%-Mode", "^User%-Agent", "^Access%-Control", "^Accept", "^Origin", "^Referer", "^Connection", "^Pragma", "^Cache-"}
    	for key=1, #ex_keys do
    		if string.find (line, ex_keys[key]) then
    			ex_match = true
    			break
    		end
    	end
    	if ex_match then break end
    	if not string.find (line, "level=") then
				if not string.find (line, "【") and not string.find (line, "】") then
   				line_trans = string.sub(line, 0, 20)..luci.i18n.translate(string.sub(line, 21, -1))
   			else
   				local no_trans = {}
   				line_trans = ""
   				local a = string.find (line, "【")
   				local b = string.find (line, "】") + 2
   				local c = 21
   				local v
   				local x
   				while true do
   					table.insert(no_trans, a)
   					table.insert(no_trans, b)
   					if string.find (line, "【", b+1) and string.find (line, "】", b+1) then
   						a = string.find (line, "【", b+1)
   						b = string.find (line, "】", b+1) + 2
   					else
   						break
   					end
   				end
   				for k = 1, #no_trans, 2 do
   					x = no_trans[k]
   					v = no_trans[k+1]
   					if x <= 21 then
   						line_trans = line_trans .. string.sub(line, 0, v)
   					elseif v <= string.len(line) then
   						line_trans = line_trans .. luci.i18n.translate(string.sub(line, c, x - 1)) .. string.sub(line, x, v)
   					end
   					c = v + 1
   				end
   				if c > string.len(line) then
   					line_trans = string.sub(line, 0, 20) .. line_trans
   				else
   					line_trans = string.sub(line, 0, 20) .. line_trans .. luci.i18n.translate(string.sub(line, c, -1))
   				end
   			end
			end
			if data == "" then
    		data = line_trans
    	elseif log_len == 0 and i == limit then
    		data = data .."\n" .. line_trans .. "\n..."
    	else
    		data = data .."\n" .. line_trans
  		end
    	break
    end
	end
	luci.http.write_json({
		len = len,
		log = data;
	})
end

function action_del_log()
	luci.sys.exec(": > /tmp/clashwrt.log")
	return
end

function action_del_start_log()
	luci.sys.exec(": > /tmp/clashwrt_start.log")
	return
end

function split(str,delimiter)
	local dLen = string.len(delimiter)
	local newDeli = ''
	for i=1,dLen,1 do
		newDeli = newDeli .. "["..string.sub(delimiter,i,i).."]"
	end

	local locaStart,locaEnd = string.find(str,newDeli)
	local arr = {}
	local n = 1
	while locaStart ~= nil
	do
		if locaStart>0 then
			arr[n] = string.sub(str,1,locaStart-1)
			n = n + 1
		end

		str = string.sub(str,locaEnd+1,string.len(str))
		locaStart,locaEnd = string.find(str,newDeli)
	end
	if str ~= nil then
		arr[n] = str
	end
	return arr
end

function action_write_netflix_domains()
	local domains = luci.http.formvalue("domains")
	local dustom_file = "/etc/clashwrt/custom/clashwrt_custom_netflix_domains.list"
	local file = io.open(dustom_file, "a+")
	file:seek("set")
	local domain = file:read("*a")
	for v, k in pairs(split(domains,"\n")) do
		if not string.find(domain,k,1,true) then
			file:write(k.."\n")
		end
	end
	file:close()
	return
end

function action_catch_netflix_domains()
	local cmd = "/usr/share/clashwrt/clashwrt_debug_getcon.lua 'netflix-nflxvideo'"
	luci.http.prepare_content("text/plain")
	local util = io.popen(cmd)
	if util and util ~= "" then
		while true do
			local ln = util:read("*l")
			if not ln then break end
			luci.http.write(ln)
			luci.http.write(",")
		end
		util:close()
		return
	end
	luci.http.status(500, "Bad address")
end

function action_diag_connection()
	local addr = luci.http.formvalue("addr")
	if addr and datatype.hostname(addr) or datatype.ipaddr(addr) then
		local cmd = string.format("/usr/share/clashwrt/clashwrt_debug_getcon.lua %s", addr)
		luci.http.prepare_content("text/plain")
		local util = io.popen(cmd)
		if util and util ~= "" then
			while true do
				local ln = util:read("*l")
				if not ln then break end
				luci.http.write(ln)
				luci.http.write("\n")
			end
			util:close()
		end
		return
	end
	luci.http.status(500, "Bad address")
end

function action_gen_debug_logs()
	local gen_log = luci.sys.call("/usr/share/clashwrt/clashwrt_debug.sh")
	if not gen_log then return end
	local logfile = "/tmp/clashwrt_debug.log"
	if not fs.access(logfile) then
		return
	end
	luci.http.prepare_content("text/plain; charset=utf-8")
	local file=io.open(logfile, "r+")
	file:seek("set")
	local info = ""
	for line in file:lines() do
		if info ~= "" then
			info = info.."\n"..line
		else
			info = line
		end
	end
	file:close()
	luci.http.write(info)
end

function action_backup()
	local config = luci.sys.call("cp /etc/config/clashwrt /etc/clashwrt/clashwrt >/dev/null 2>&1")
	local reader = ltn12_popen("tar -C '/etc/clashwrt/' -cz . 2>/dev/null")

	luci.http.header(
		'Content-Disposition', 'attachment; filename="Backup-clashwrt-%s.tar.gz"' %{
			os.date("%Y-%m-%d-%H-%M-%S")
		})

	luci.http.prepare_content("application/x-targz")
	luci.ltn12.pump.all(reader, luci.http.write)
end

function ltn12_popen(command)

	local fdi, fdo = nixio.pipe()
	local pid = nixio.fork()

	if pid > 0 then
		fdo:close()
		local close
		return function()
			local buffer = fdi:read(2048)
			local wpid, stat = nixio.waitpid(pid, "nohang")
			if not close and wpid and stat == "exited" then
				close = true
			end

			if buffer and #buffer > 0 then
				return buffer
			elseif close then
				fdi:close()
				return nil
			end
		end
	elseif pid == 0 then
		nixio.dup(fdo, nixio.stdout)
		fdi:close()
		fdo:close()
		nixio.exec("/bin/sh", "-c", command)
	end
end