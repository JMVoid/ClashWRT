#!/bin/sh
. /usr/share/openclash/log.sh

set_lock() {
   exec 878>"/tmp/lock/openclash_update.lock" 2>/dev/null
   flock -x 878 2>/dev/null
}

del_lock() {
   flock -u 878 2>/dev/null
   rm -rf "/tmp/lock/openclash_update.lock"
}

#一键更新
# if [ "$1" = "one_key_update" ]; then
#    uci set openclash.config.enable=1
#    uci commit openclash
#    /usr/share/openclash/openclash_core.sh "$1" >/dev/null 2>&1 &
#    /usr/share/openclash/openclash_core.sh "TUN" "$1" >/dev/null 2>&1 &
#    wait
# fi

LAST_CWRT_VER="/tmp/clashwrt_last_version"
LAST_VER=$(sed -n 1p "$LAST_OPVER" 2>/dev/null |sed "s/^v//g" |tr -d "\n")
OP_CV=$(sed -n 1p /usr/share/clashwrt/res/clashwrt_version 2>/dev/null |awk -F '-' '{print $1}' |awk -F 'v' '{print $2}' |awk -F '.' '{print $2$3}' 2>/dev/null)
OP_LV=$(sed -n 1p $LAST_OPVER 2>/dev/null |awk -F '-' '{print $1}' |awk -F 'v' '{print $2}' |awk -F '.' '{print $2$3}' 2>/dev/null)
RELEASE_BRANCH=$(uci -q get clashwrt.config.release_branch || echo "master")
set_lock

if [ "$(expr "$OP_LV" \> "$OP_CV")" -eq 1 ] && [ -f "$LAST_OPVER" ]; then
   LOG_OUT "Start Downloading【ClashWRT - v$LAST_VER】..."
   if [ "$RELEASE_BRANCH" = "dev" ]; then
      curl -sL -m 10 --retry 2 https://raw.githubusercontent.com/JMVoid/ClashWRT/"$RELEASE_BRANCH"/luci-app-clashwrt_"$LAST_VER"_all.ipk -o /tmp/clashwrt.ipk >/dev/null 2>&1
   else
      if pidof clash_tun >/dev/null; then
         curl -sL -m 10 --retry 2 https://github.com/JMVoid/ClashWRT/releases/download/v"$LAST_VER"/luci-app-clashwrt"$LAST_VER"_all.ipk -o /tmp/clashwrt.ipk >/dev/null 2>&1
      fi
   fi
   
   if [ "$?" -ne "0" ] || ! pidof clash_tun >/dev/null; then
      curl -sL -m 10 --retry 2 https://cdn.jsdelivr.net/gh/JMVoid/ClashWRT@"$RELEASE_BRANCH"/luci-app-clashwrt_"$LAST_VER"_all.ipk -o /tmp/clashwrt.ipk >/dev/null 2>&1
   fi
   
   if [ "$?" -eq "0" ] && [ -s "/tmp/clashwrt.ipk" ]; then
      LOG_OUT "【ClashWRT - v$LAST_VER】Download Successful, Start Pre Update Test..."
      opkg install /tmp/clashwrt.ipk --noaction >>$LOG_FILE
      if [ "$?" -ne "0" ]; then
         LOG_OUT "【ClashWRT - v$LAST_VER】Pre Update Test Failed, The File is Saved in /tmp/clashwrt.ipk, Please Try to Update Manually!"
         sleep 3
         SLOG_CLEAN
         del_lock
         exit 0
      fi
      LOG_OUT "【ClashWRT - v$LAST_VER】Pre Update Test Passed, Ready to Update and Please Do not Refresh The Page and Other Operations..."
      cat > /tmp/clashwrt_update.sh <<"EOF"
#!/bin/sh
START_LOG="/tmp/clashwrt_start.log"
LOG_FILE="/tmp/clashwrt.log"
LOGTIME=$(date "+%Y-%m-%d %H:%M:%S")
		
LOG_OUT()
{
	if [ -n "${1}" ]; then
		echo -e "${1}" > $START_LOG
		echo -e "${LOGTIME} ${1}" >> $LOG_FILE
	fi
}

SLOG_CLEAN()
{
	echo "" > $START_LOG
}

LOG_OUT "Uninstalling The Old Version, Please Do not Refresh The Page or Do Other Operations..."
uci set clashwrt.config.enable=0
uci commit clashwrt
opkg remove --force-depends --force-remove luci-app-clashwrt
LOG_OUT "Installing The New Version, Please Do Not Refresh The Page or Do Other Operations..."
opkg install /tmp/clashwrt.ipk
if [ "$?" -eq "0" ]; then
   rm -rf /tmp/clashwrt.ipk >/dev/null 2>&1
   LOG_OUT "ClashWRT Update Successful, About To Restart!"
   sleep 3
   uci set clashwrt.config.enable=1
   uci commit clashwrt
   /etc/init.d/clashwrt restart 2>/dev/null
else
   LOG_OUT "ClashWRT Update Failed, The File is Saved in /tmp/clashwrt.ipk, Please Try to Update Manually!"
   sleep 3
   SLOG_CLEAN
fi
EOF
   chmod 4755 /tmp/clashwrt_update.sh
   nohup /tmp/clashwrt_update.sh &
   wait
   rm -rf /tmp/clashwrt_update.sh
   else
      LOG_OUT "【ClashWRT - v$LAST_VER】Download Failed, Please Check The Network or Try Again Later!"
      rm -rf /tmp/clashwrt.ipk >/dev/null 2>&1
      sleep 3
      SLOG_CLEAN
      if [ "$(uci get clashwrt.config.config_reload 2>/dev/null)" -eq 0 ]; then
         uci set clashwrt.config.config_reload=1
         uci commit clashwrt
      	 /etc/init.d/clashwrt restart 2>/dev/null
      fi
   fi
else
   if [ ! -f "$LAST_OPVER" ]; then
      LOG_OUT "Failed to Get Version Information, Please Try Again Later..."
      sleep 3
      SLOG_CLEAN
   else
      LOG_OUT "ClashWRT Has not Been Updated, Stop Continuing!"
      sleep 3
      SLOG_CLEAN
   fi
   if [ "$(uci get clashwrt.config.config_reload 2>/dev/null)" -eq 0 ]; then
      uci set clashwrt.config.config_reload=1
      uci commit clashwrt
      /etc/init.d/clashwrt restart 2>/dev/null
   fi
fi
del_lock