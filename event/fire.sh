
shelduck import ../base.sh
shelduck import ../string.sh
shelduck import ../misc/defun.sh

bobshell_event_fire() {
	if bobshell_command_available "$1"; then
		"$@"
		return
	fi

	_bobshell_event_fire__name="$1"
	shift
	_bobshell_event_fire__code=$(bobshell_getvar "$_bobshell_event_fire__name" '')
	if bobshell_isset "${_bobshell_event_fire__name}_template"; then
		_bobshell_event_fire__template=$(bobshell_getvar "${_bobshell_event_fire__name}_template")
		_bobshell_event_fire__code=$(bobshell_replace "$_bobshell_event_fire__template" '{}' "$_bobshell_event_fire__code")
		unset _bobshell_event_fire__template
	fi
	if [ -n "$_bobshell_event_fire__code" ]; then
		bobshell_defun "$_bobshell_event_fire__name" "$_bobshell_event_fire__code"
	else
		bobshell_defun "$_bobshell_event_fire__name" true
	fi
	unset _bobshell_event_fire__code

	"$_bobshell_event_fire__name" "$@"
	unset _bobshell_event_fire__name
}
