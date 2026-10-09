


shelduck import ../base.sh
shelduck import ../string.sh
shelduck import ../result/set.sh
shelduck import ./compile.sh
shelduck import ../misc/defun.sh
shelduck import ../var/append.sh



bobshell_event_listen() {
	_bobshell_event_listen__name="$1"
	shift

	if [ eval = "${1:-}" ]; then
		shift
	fi


	if [ "$*" ]; then
		bobshell_var_get "$_bobshell_event_listen__name"
		if ! bobshell_result_check _bobshell_event_listen__script; then
			_bobshell_event_listen__script=
		fi

		_bobshell_event_listen__script="$_bobshell_event_listen__script

$*

"


		# todo refactor
		if ! bobshell_isset "${_bobshell_event_listen__name}_template"; then
			_bobshell_event_listen__script="$_bobshell_event_listen__script"'
if [ true = "${_bobshell_event_stop_flag:-false}" ]; then
	unset _bobshell_event_stop_flag
	return
fi
'
		fi

		bobshell_var_set "$_bobshell_event_listen__name" "$_bobshell_event_listen__script"
		unset _bobshell_event_listen__script
	elif bobshell_command_available "$_bobshell_event_listen__name"; then
		return
	fi
	unset _bobshell_event_listen__listener

	# shellcheck disable=SC2016
	bobshell_defun "$_bobshell_event_listen__name" "bobshell_event_compile $_bobshell_event_listen__name
$_bobshell_event_listen__name \"\$@\""
	unset _bobshell_event_listen__name

}
