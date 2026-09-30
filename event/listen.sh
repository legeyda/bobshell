
shelduck import ../append/val_to_var.sh
shelduck import ../string.sh
shelduck import ../result/set.sh
shelduck import ./compile.sh
shelduck import ../misc/defun.sh

bobshell_event_listen() {
	_bobshell_event_listen__name="$1"
	shift

	if [ eval = "${1:-}" ]; then
		shift
	fi

	if [ "${*:-}" ]; then
		bobshell_append_val_to_var "$bobshell_newline$bobshell_newline$*$bobshell_newline" "$_bobshell_event_listen__name"
	elif bobshell_command_available "$_bobshell_event_listen__name"; then
	    return
	fi

	# shellcheck disable=SC2016
	bobshell_defun "$_bobshell_event_listen__name" "bobshell_event_compile $_bobshell_event_listen__name
$_bobshell_event_listen__name \"\$@\""
	unset _bobshell_event_listen__name
}
