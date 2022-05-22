#!/bin/sh
#
# This software may be modified and distributed under the terms
# of the MIT license.  See the LICENSE file for details.
#
#
# This script queries the node statistics from respondd and
# enables/disables some LEDs according to the read information:
#
# QSS - blink if load or nvram usage beyond the threshold or if free memory is below the threshold
# WAN - blink if fastd is not running (i.e. no gateway assigned)
# WLAN - enable if there are any clients connected
#
# All other LEDs are left as they are.
# Should work on many TP models, tested only on TL-WR841N v9.
# In doubt, see https://openwrt.org/docs/guide-user/base-system/led_configuration#led_triggers.


LED_COLOR="green"
THRESHOLD_LOW_MEMORY=3072 # 3 MB
THRESHOLD_HIGH_LOAD=0.8
THRESHOLD_NVRAM_USAGE=0.85 # 85 %


. /usr/share/libubox/jshn.sh


log() {
	level=$1
	message="$2"

	logger -t sh -p cron.${level} "set_led_status.sh: ${message}"
}


query_statistics() {
	statistics=$(gluon-neighbour-info -d ::1 -p 1001 -c 1 -r statistics)
	if [ $? != 0 ]; then
		log error "Fetching statistics failed"
		exit 1
	fi
	json_load "${statistics}"
}


fetch_loadavg() {
	json_get_var loadavg loadavg
}


fetch_nvram_usage() {
	json_get_var nvram_usage rootfs_usage
}


fetch_memory() {
	json_select memory
	json_get_var memory_free free
}


fetch_fastd_running() {
	json_select ..
	json_get_var gateway gateway
}


fetch_client_count() {
	json_select clients
	json_get_var client_count total
}


set_led_status_qss() {
	# LED QSS = hight load / low memory indicator
	status=0
	trigger="none"

	if [ $(echo "${loadavg} ${THRESHOLD_HIGH_LOAD}" | awk '{print ($1 > $2)}') = 1 ]; then
		status=1
		trigger="timer"
	fi

	if [ $(echo "${nvram_usage} ${THRESHOLD_NVRAM_USAGE}" | awk '{print ($1 > $2)}') = 1 ]; then
		status=1
		trigger="timer"
	fi

	if [ ${memory_free} -le ${THRESHOLD_LOW_MEMORY} ]; then
		status=1
		trigger="timer"
	fi

	set_led_status qss ${status} ${trigger}
}


set_led_status_wan() {
	# LED WAN = fastd running?
	if [ -z ${gateway} ]; then
		set_led_status wan 1 timer
	else
		set_led_status wan 0 none
	fi
}


set_led_status_wlan() {
	# LED WLAN = clients connected?
	if [ ${client_count} -gt 0 ]; then
		set_led_status wlan 1 none
	else
		set_led_status wlan 0 none
	fi
}


set_led_status() {
	led=$1
	status=$2
	trigger=$3

	echo "${trigger}" > /sys/class/leds/tp-link:${LED_COLOR}:${led}/trigger
	echo "${status}" > /sys/class/leds/tp-link:${LED_COLOR}:${led}/brightness

	RESULTING_LED_STATUS="${RESULTING_LED_STATUS} ${led}:${status}"
}


main() {
	RESULTING_LED_STATUS=""

	query_statistics
	fetch_loadavg
	fetch_nvram_usage
	fetch_memory
	fetch_fastd_running
	fetch_client_count

	set_led_status_qss
	set_led_status_wan
	set_led_status_wlan

	log notice "Successfully set LED status -${RESULTING_LED_STATUS}"
}


main
