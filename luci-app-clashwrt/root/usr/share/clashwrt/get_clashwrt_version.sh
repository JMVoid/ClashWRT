#!/bin/sh
. $IPKG_INSTROOT/usr/share/clashwrt/log.sh

CKTIME=$(date "+%Y-%m-%d-%H")
LAST_CWRT_VER="/tmp/clashwrt_last_version"
RELEASE_BRANCH=$(uci -q get clashwrt.config.release_branch || echo "master")
CWRT_CV=$(sed -n 1p /usr/share/clashwrt/res/claswrt_version 2>/dev/null |awk -F '-' '{print $1}' |awk -F 'v' '{print $2}' |awk -F '.' '{print $2$3}' 2>/dev/null)
CWRT_LV=$(sed -n 1p $LAST_OPVER 2>/dev/null |awk -F '-' '{print $1}' |awk -F 'v' '{print $2}' |awk -F '.' '{print $2$3}' 2>/dev/null)

if [ "$CKTIME" != "$(grep "CheckTime" $LAST_CWRT_VER 2>/dev/null |awk -F ':' '{print $2}')" ]; then
   if pidof clash >/dev/null; then
      curl -sL --connect-timeout 10 --retry 2 https://raw.githubusercontent.com/JMVoid/ClashWRT/"$RELEASE_BRANCH"/version -o $LAST_CWRT_VER >"$DEBUG_LOG"  2>&1
   fi
   if [ "$?" -ne "0" ] || ! pidof clash >/dev/null; then
      curl -sL --connect-timeout 10 --retry 2 https://cdn.jsdelivr.net/gh/JMVoid/ClashWRT@"$RELEASE_BRANCH"/version -o $LAST_CWRT_VER >> "$DEBUG_LOG" 2>&1
   fi
   if [ "$?" -eq "0" ] && [ -s "$LAST_CWRT_VER" ]; then
   	  OP_LV=$(sed -n 1p $LAST_CWRT_VER 2>/dev/null |awk -F '-' '{print $1}' |awk -F 'v' '{print $2}' |awk -F '.' '{print $2$3}' 2>/dev/null)
      if [ "$(expr "$CWRT_CV" \>= "$CWRT_LV")" -eq 1 ]; then
         sed -i "/^https:/i\CheckTime:${CKTIME}" "$LAST_CWRT_VER" 2>/dev/null
         sed -i '/^https:/,$d' $LAST_CWRT_VER
      elif [ "$(expr "$CWRT_LV" \> "$CWRT_CV")" -eq 1 ] && [ -n "$CWRT_LV" ]; then
         sed -i "/^https:/i\CheckTime:${CKTIME}" "$LAST_CWRT_VER" 2>/dev/null
         return 2
      fi
   else
      rm -rf "$LAST_CWRT_VER"
   fi
elif [ "$(expr "$CWRT_CV" \>= "$CWRT_LV")" -eq 1 ]; then
   sed -i '/^CheckTime:/,$d' $LAST_CWRT_VER
   echo "CheckTime:$CKTIME" >> $LAST_CWRT_VER
elif [ "$(expr "$CWRT_LV" \> "$CWRT_CV")" -eq 1 ] && [ -n "$OP_LV" ]; then
   return 2
fi 2>/dev/null