
shelduck import ../append/val_to_var.sh
shelduck import ../string.sh
shelduck import ../result/set.sh

bobshell_event_listen() {
	_bobshell_event_listen__name="$1"
	shift
	if [ -z "${*:-}" ]; then
		return
	fi
	_bobshell_event_listen__code=$(bobshell_getvar "$_bobshell_event_listen__name" '')
	_bobshell_event_listen__code="$_bobshell_event_listen__code

$*
"

	bobshell_putvar "$_bobshell_event_listen__name" "$_bobshell_event_listen__code"
	unset _bobshell_event_listen__code
	unset -f "$_bobshell_event_listen__name"
	unset _bobshell_event_listen__name 
}
