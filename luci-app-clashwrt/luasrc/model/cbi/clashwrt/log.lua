--
local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"

m = Map("clashwrt", translate("Server Logs"))
s = m:section(TypedSection, "clashwrt")
m.pageaction = false
s.anonymous = true
s.addremove=false

log = s:option(TextValue, "clog")
log.readonly=true
log.pollcheck=true
log.template="clashwrt/log"
log.description = translate("")
log.rows = 29


return m