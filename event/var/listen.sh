
shelduck import ../listen.sh

bobshell_event_var_listen() {
	_bobshell_event_var_listen__event="$1"
	shift
	bobshell_event_listen "_bobshell_event_var_${_bobshell_event_var_listen__event}_event" "$@"
	unset _bobshell_event_var_listen__event
}
