#!/bin/sh

START_LOG="/tmp/clashwrt_start.log"
LOG_FILE="/tmp/clashwrt.log"
DEBUG_LOG="/dev/null"

debug_log_toggle() {
   log_level=$(uci -q get clashwrt.config.log_level)
   if [[ "$log_level" == "debug" ]]; then
      DEBUG_LOG="$LOG_FILE"
   fi
}

debug_log_toggle

LOG_OUT()
{
	if [ -n "${1}" ]; then
		echo -e "${1}" > $START_LOG
		echo -e "$(date "+%Y-%m-%d %H:%M:%S") ${1}" >> $LOG_FILE
	fi
}

LOG_ALERT()
{
	echo -e "$(tail -n 20 $LOG_FILE |grep 'level=fatal' |awk 'END {print}')" > $START_LOG
	sleep 3
}

SLOG_CLEAN()
{
	echo "" > $START_LOG
}

