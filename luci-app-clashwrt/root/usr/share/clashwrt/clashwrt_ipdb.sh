#!/bin/sh
. /usr/share/clashwrt/clashwrt_ps.sh
. /usr/share/clashwrt/log.sh

   set_lock() {
      exec 880>"/tmp/lock/clashwrt_ipdb.lock" 2>/dev/null
      flock -x 880 2>/dev/null
   }

   del_lock() {
      flock -u 880 2>/dev/null
      rm -rf "/tmp/lock/clashwrt_ipdb.lock"
   }

   small_flash_memory=$(uci get clashwrt.config.small_flash_memory 2>/dev/null)
   GEOIP_CUSTOM_URL=$(uci get clashwrt.config.geo_custom_url 2>/dev/null)
   set_lock
   
   if [ "$small_flash_memory" != "1" ]; then
   	  geoip_path="/etc/clashwrt/Country.mmdb"
   	  mkdir -p /etc/clashwrt
   else
   	  geoip_path="/tmp/etc/clashwrt/Country.mmdb"
   	  mkdir -p /tmp/etc/clashwrt
   fi
   LOG_OUT "Start Downloading Geoip Database..."
   if [ -z "$GEOIP_CUSTOM_URL" ]; then
      if pidof clash >/dev/null; then
         curl -sL --connect-timeout 10 --retry 2 https://raw.githubusercontent.com/alecthw/mmdb_china_ip_list/release/lite/Country.mmdb -o /tmp/Country.mmdb >/dev/null 2>&1
      fi
      if [ "$?" -ne "0" ] || ! pidof clash >/dev/null; then
         curl -sL --connect-timeout 10 --retry 2 https://cdn.jsdelivr.net/gh/alecthw/mmdb_china_ip_list@release/lite/Country.mmdb -o /tmp/Country.mmdb >/dev/null 2>&1
      fi
   else
      curl -sL --connect-timeout 10 --retry 2 "$GEOIP_CUSTOM_URL" -o /tmp/Country.mmdb >/dev/null 2>&1
   fi
   if [ "$?" -eq "0" ] && [ -s "/tmp/Country.mmdb" ]; then
      LOG_OUT "Geoip Database Download Success, Check Updated..."
      cmp -s /tmp/Country.mmdb "$geoip_path"
      if [ "$?" -ne "0" ]; then
         LOG_OUT "Geoip Database Has Been Updated, Starting To Replace The Old Version..."
         mv /tmp/Country.mmdb "$geoip_path" >/dev/null 2>&1
         LOG_OUT "Geoip Database Update Successful!"
         sleep 3
         [ "$(unify_ps_prevent)" -eq 0 ] && /etc/init.d/clashwrt restart >/dev/null 2>&1 &
      else
         LOG_OUT "Updated Geoip Database No Change, Do Nothing..."
         sleep 3
      fi
   else
      LOG_OUT "Geoip Database Update Error, Please Try Again Later..."
      sleep 3
   fi
   rm -rf /tmp/Country.mmdb >/dev/null 2>&1
   SLOG_CLEAN
   del_lock