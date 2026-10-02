
shelduck import ../base.sh
shelduck import ../string.sh
shelduck import ../misc/defun.sh

bobshell_event_compile() {
	_bobshell_event_compile__name="$1"
	shift
	_bobshell_event_compile__code=$(bobshell_getvar "$_bobshell_event_compile__name" '')
	if bobshell_isset "${_bobshell_event_compile__name}_template"; then
		_bobshell_event_compile__template=$(bobshell_getvar "${_bobshell_event_compile__name}_template")
		_bobshell_event_compile__code=$(bobshell_replace "$_bobshell_event_compile__template" '{}' "$_bobshell_event_compile__code")
		unset _bobshell_event_compile__template
	fi

	bobshell_defun "$_bobshell_event_compile__name" '
if [ true = "${_bobshell_event_running_flag_'"$_bobshell_event_compile__name"':-false}" ]; then
	bobshell_die recursive event fire not allowed
fi
_bobshell_event_last_event='"$_bobshell_event_compile__name"'
_bobshell_event_running_flag_'"$_bobshell_event_compile__name"'=true
unset _bobshell_event_stop_flag_'"$_bobshell_event_compile__name"'

'"$_bobshell_event_compile__name"'_wrap "$@"

unset _bobshell_event_running_flag_'"$_bobshell_event_compile__name"'
unset _bobshell_event_stop_flag_'"$_bobshell_event_compile__name"'
'

	bobshell_defun "$_bobshell_event_compile__name"_wrap "${_bobshell_event_compile__code:-true}"

	unset _bobshell_event_compile__name _bobshell_event_compile__code
}
