#!/bin/sh
. /lib/functions.sh
. /usr/share/clashwrt/clashwrt_ps.sh
. /usr/share/clashwrt/log.sh

CORE_TYPE="$1"
C_CORE_TYPE=$(uci get clashwrt.config.core_type 2>/dev/null)
[ -z "$CORE_TYPE" ] || [ "$1" = "one_key_update" ] && CORE_TYPE="Dev"
small_flash_memory=$(uci get clashwrt.config.small_flash_memory 2>/dev/null)
CPU_MODEL=$(uci get clashwrt.config.core_version 2>/dev/null)
RELEASE_BRANCH=$(uci -q get clashwrt.config.release_branch || echo "master")
[ ! -f "/tmp/clash_last_version" ] && /usr/share/openclash/clash_version.sh 2>/dev/null
if [ ! -f "/tmp/clash_last_version" ]; then
   LOG_OUT "Error: 【"$CORE_TYPE"】Core Version Check Error, Please Try Again Later..."
   sleep 3
   SLOG_CLEAN
   exit 0
fi

if [ "$small_flash_memory" != "1" ]; then
   dev_core_path="/etc/clashwrt/core/clash"
   tun_core_path="/etc/clashwrt/core/clash_tun"
   mkdir -p /etc/clashwrt/core
else
   dev_core_path="/tmp/etc/clashwrt/core/clash"
   tun_core_path="/tmp/etc/clashwrt/core/clash_tun"
   mkdir -p /tmp/etc/openclash/core
fi

case $CORE_TYPE in
	"TUN")
   CORE_CV=$($tun_core_path -v 2>/dev/null |awk -F ' ' '{print $2}')
   CORE_LV=$(sed -n 1p /tmp/clash_last_version 2>/dev/null)
   if [ -z "$CORE_LV" ]; then
      LOG_OUT "Error: 【"$CORE_TYPE"】Core Version Check Error, Please Try Again Later..."
      sleep 3
      SLOG_CLEAN
      exit 0
   fi
   ;;
   *)
   LOG_OUT "dev core mode have been deprecated"
   # CORE_CV=$($dev_core_path -v 2>/dev/null |awk -F ' ' '{print $2}')
   # CORE_LV=$(sed -n 1p /tmp/clash_last_version 2>/dev/null)
esac
   
[ "$C_CORE_TYPE" = "$CORE_TYPE" ] || [ -z "$C_CORE_TYPE" ] && if_restart=1
[ -n "$2" ] || [ "$1" = "one_key_update" ] && if_restart=0
if [ "$CORE_CV" != "$CORE_LV" ] || [ -z "$CORE_CV" ]; then
   LOG_OUT "core_cv=core_lv $CPU_MODEL  $RELEASE_BRANCH $CORE_TYPE"
   if [ "$CPU_MODEL" != 0 ]; then
      LOG_OUT "cpu_model no equal 0 $CPU_MODEL"
      if [ "$RELEASE_BRANCH" = "dev" ]; then
         LOG_OUT "RELEASE_BRANCH not dev $RELEASE_BRANCH"
         case $CORE_TYPE in
            "TUN")
               LOG_OUT "【Tun】Core Downloading, Please Try to Download and Upload Manually If Fails"
			         curl -sL -m 10 --retry 2 https://github.com/Dreamacro/clash/releases/download/premium/clash-"$CPU_MODEL"-"$CORE_LV".gz -o /tmp/clash_tun.gz >/dev/null 2>&1
			      ;;
			      *)
			         LOG_OUT "【Dev】Core Downloading, Please Try to Download and Upload Manually If Fails"
			         curl -sL -m 10 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/"$RELEASE_BRANCH"/core-lateset/dev/clash-"$CPU_MODEL".tar.gz -o /tmp/clash.tar.gz >/dev/null 2>&1
			   esac
      else
			   case $CORE_TYPE in
            "TUN")
                  LOG_OUT "【Tun】Core Downloading, Please Try to Download and Upload Manually If Fails $CORE_TYPE $CPU_MODEL - $CORE_LV"
			         curl -sL -m 10 --retry 2 https://github.com/Dreamacro/clash/releases/download/premium/clash-"$CPU_MODEL"-"$CORE_LV".gz -o /tmp/clash_tun.gz >/dev/null 2>&1
			      ;;
			      *)
			         LOG_OUT "【Dev】Core Downloading, Please Try to Download and Upload Manually If Fails"
			      	curl -sL -m 10 --retry 2 https://github.com/vernesong/OpenClash/releases/download/Clash/clash-"$CPU_MODEL".tar.gz -o /tmp/clash.tar.gz >/dev/null 2>&1
			   esac
      fi
      # if [ "$?" -ne "0" ] || ! pidof clash >/dev/null; then
		# 	   case $CORE_TYPE in
      #    "TUN")
      #       LOG_OUT "【Tun】Core Downloading, Please Try to Download and Upload Manually If Fails"
      #       curl -sL -m 10 --retry 2 https://cdn.jsdelivr.net/gh/vernesong/OpenClash@"$RELEASE_BRANCH"/core-lateset/premium/clash-"$CPU_MODEL"-"$CORE_LV".gz -o /tmp/clash_tun.gz >/dev/null 2>&1
		# 	   	;;
		# 	   	*)
      #       LOG_OUT "【Dev】Core Downloading, Please Try to Download and Upload Manually If Fails"
      #       curl -sL -m 10 --retry 2 https://cdn.jsdelivr.net/gh/vernesong/OpenClash@"$RELEASE_BRANCH"/core-lateset/dev/clash-"$CPU_MODEL".tar.gz -o /tmp/clash.tar.gz >/dev/null 2>&1
		# 	   esac
      # fi
      
      if [ "$?" -eq "0" ]; then
         LOG_OUT "【"$CORE_TYPE"】Core Download Successful, Start Update..."
	      case $CORE_TYPE in
         	"TUN")
		      [ -s "/tmp/clash_tun.gz" ] && {
            gzip -d /tmp/clash_tun.gz >/dev/null 2>&1
		      rm -rf /tmp/clash_tun.gz >/dev/null 2>&1
			   rm -rf "$tun_core_path" >/dev/null 2>&1
			   chmod 4755 /tmp/clash_tun >/dev/null 2>&1
			   }
			   ;;
			   *)
			   [ -s "/tmp/clash.tar.gz" ] && {
            rm -rf "$dev_core_path" >/dev/null 2>&1
            if [ "$small_flash_memory" != "1" ]; then
               tar zxvf /tmp/clash.tar.gz -C /etc/clashwrt/core
            else
				   tar zxvf /tmp/clash.tar.gz -C /tmp/etc/clashwrt/core
            fi
				   rm -rf /tmp/clash.tar.gz >/dev/null 2>&1
				   chmod 4755 "$dev_core_path" >/dev/null 2>&1
            }
         esac
         if [ "$?" -ne "0" ]; then
            LOG_OUT "【"$CORE_TYPE"】Core Update Failed, Please Check The Network or Try Again Later!"
            case $CORE_TYPE in
            "TUN")
               rm -rf /tmp/clash_tun >/dev/null 2>&1
				    ;;
				    *)
            esac
            sleep 3
            SLOG_CLEAN
            exit 0
         fi
      
         if [ "$if_restart" -eq 1 ]; then
      	    clash_pids=$(pidof clash |sed 's/$//g')
            for clash_pid in $clash_pids; do
               kill -9 "$clash_pid" 2>/dev/null
            done
         fi
      
			case $CORE_TYPE in
            "TUN")
			      mv /tmp/clash_tun "$tun_core_path" >/dev/null 2>&1
			   ;;
			   *)
			esac
         if [ "$?" -eq "0" ]; then
            LOG_OUT "【"$CORE_TYPE"】Core Update Successful!"
            sleep 3
            if [ -n "$2" ] || [ "$1" = "one_key_update" ]; then
         	    uci set clashwrt.config.config_reload=0
         	    uci commit clashwrt
            fi
            [ "$if_restart" -eq 1 ] && [ "$(unify_ps_prevent)" -eq 0 ] && /etc/init.d/clashwrt restart
            SLOG_CLEAN
         else
            LOG_OUT "【"$CORE_TYPE"】Core Update Failed. Please Make Sure Enough Flash Memory Space And Try Again!"
            case $CORE_TYPE in
            "TUN")
				       rm -rf /tmp/clash_tun >/dev/null 2>&1
				    ;;
				    *)
			      esac
            sleep 3
            SLOG_CLEAN
         fi
      else
         LOG_OUT "【"$CORE_TYPE"】Core Update Failed, Please Check The Network or Try Again Later!"
         case $CORE_TYPE in
         "TUN")
			      rm -rf /tmp/clash_tun >/dev/null 2>&1
			   ;;
			   *)
			      rm -rf /tmp/clash >/dev/null 2>&1
		     esac
         sleep 3
         SLOG_CLEAN
      fi
   else
      LOG_OUT "No Compiled Version Selected, Please Select In Global Settings And Try Again!"
      sleep 3
      SLOG_CLEAN
   fi
else
   LOG_OUT "【"$CORE_TYPE"】Core Has Not Been Updated, Stop Continuing Operation!"
   sleep 3
   SLOG_CLEAN
fi
