


shelduck import ./set.sh

# fun: bobshell_event_var_mimic DESTVAR SRCVAR
# use: bobshell_event_var_listen param mylistener; bobshell_event_var_mimic param parsed_cli_param
bobshell_event_var_mimic() {
	if bobshell_isset "$2"; then
		_bobshell_event_var_mimic__value=$(bobshell_getvar "$2")
		bobshell_event_var_set "$1" "$_bobshell_event_var_mimic__value"
		unset _bobshell_event_var_mimic__value
	else
		bobshell_event_var_set "$1"
	fi
}