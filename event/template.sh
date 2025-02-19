

shelduck import ../base.sh


bobshell_event_template() {
	if bobshell_isset_2 "$@"; then
		if bobshell_isset "${1}_template"; then
			_bobshell_event_template=$(bobshell_getvar "${1}_template")
			if [ "$_bobshell_event_template" == "$2" ]; then
				unset _bobshell_event_template
				return
			fi
			unset _bobshell_event_template
		fi
		bobshell_putvar "${1}_template" "$2"
	else
		if bobshell_isset "${1}_template"; then
			unset "${1}_template"
		else
			return
		fi
	fi
	unset -f "$1"
}