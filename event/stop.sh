
shelduck import ../base.sh
shelduck import ../string.sh
shelduck import ../result/set.sh
shelduck import ./compile.sh
shelduck import ../misc/defun.sh
shelduck import ../var/append.sh

bobshell_event_stop() {
	if ! bobshell_isset _bobshell_event_last_event; then
		bobshell_die bobshell_event_stop: no handling event, cannot stop
	fi

	bobshell_var_get _bobshell_event_running_flag_"$_bobshell_event_last_event"
	if ! bobshell_result_check _bobshell_event_stop__running_flag; then
		bobshell_die bobshell_event_stop: no handling event, cannot stop
	fi

	if [ true != "${_bobshell_event_stop__running_flag:-false}" ]; then
		bobshell_die bobshell_event_stop: no handling event, cannot stop
	fi

	bobshell_var_set _bobshell_event_stop_flag_"$_bobshell_event_last_event" true
	unset _bobshell_event_stop__running_flag
}
