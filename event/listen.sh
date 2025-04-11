
shelduck import ../append/val_to_var.sh
shelduck import ../string.sh
shelduck import ../result/set.sh
shelduck import ./compile.sh
shelduck import ../misc/defun.sh

bobshell_event_listen() {
	_bobshell_event_listen__name="$1"
	shift
	if [ -z "${*:-}" ]; then
		return
	fi
	bobshell_append_val_to_var "$bobshell_newline$bobshell_newline$*$bobshell_newline" "$_bobshell_event_listen__name"

	# shellcheck disable=SC2016
	bobshell_defun "$_bobshell_event_listen__name" "bobshell_event_compile $_bobshell_event_listen__name
$_bobshell_event_listen__name \"\$@\""
	unset _bobshell_event_listen__name
}
