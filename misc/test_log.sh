shelduck import ../assert.sh
shelduck import ./log.sh



test_log() {
	unset DEBUG BOBSHELL_LOG_LEVEL

	bobshell_log_init
	assert_equals 3 "$_bobshell_log_level"

	#
	check_log_level 0 EMERG
	check_log_level 1 ALERT
	check_log_level 2 CRIT
	check_log_level 3 ERR
	check_log_level 3 ERROR
	check_log_level 4 WARN
	check_log_level 4 WARNING
	check_log_level 5 NOTICE
	check_log_level 6 INF
	check_log_level 6 INFO
	check_log_level 7 DEBUG
	check_log_level 8 TRACE

	check_debug_level 3 ''
	check_debug_level 3 0
	check_debug_level 5 1
	check_debug_level 5 true
	check_debug_level 6 2
	check_debug_level 7 3



}


check_log_level() {
	unset DEBUG
	BOBSHELL_LOG_LEVEL="$2"
	bobshell_log_init
	assert_equals "$1" "$_bobshell_log_level"
}

check_debug_level() {
	unset BOBSHELL_LOG_LEVEL
	DEBUG="$2"
	bobshell_log_init
	assert_equals "$1" "$_bobshell_log_level"
}

test_lazy() {
	unset DEBUG BOBSHELL_LOG_LEVEL
	DEBUG=2
	bobshell_log_trace touch
	assert_equals 6 "$_bobshell_log_level"

	x=$(bobshell_log_info hello 2>&1)
	assert_equals 'info: hello' "$x"
}
