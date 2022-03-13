#!/bin/sh

unify_ps_status() {
	if [ "$(ps --version 2>&1 |grep -c procps-ng)" -eq 1 ];then
		echo "$(ps -efw |grep -v grep |grep -c "$1")"
	else
		echo "$(ps -w |grep -v grep |grep -c "$1")"
	fi
}

unify_ps_pids() {
	if [ "$(ps --version 2>&1 |grep -c procps-ng)" -eq 1 ];then
		echo "$(ps -efw |grep "$1" |grep -v grep |awk '{print $2}' 2>/dev/null)"
	else
		echo "$(ps -w |grep "$1" |grep -v grep |awk '{print $1}' 2>/dev/null)"
	fi
}

unify_ps_prevent() {
	if [ "$(ps --version 2>&1 |grep -c procps-ng)" -eq 1 ];then
		echo "$(ps -efw |grep -v grep |grep -c "/etc/init.d/clashwrt")"
	else
		echo "$(ps -w |grep -v grep |grep -c "/etc/init.d/clashwrt")"
	fi
}

unify_ps_cfgname() {
	if [ "$(ps --version 2>&1 |grep -c procps-ng)" -eq 1 ];then
		echo "$(ps -efw |grep /etc/clashwrt/clash 2>/dev/null |grep -v grep |awk -F '-f ' '{print $2}' 2>/dev/null)"
	else
		echo "$(ps -w |grep /etc/clashwrt/clash 2>/dev/null |grep -v grep |awk -F '-f ' '{print $2}' 2>/dev/null)"
	fi
}