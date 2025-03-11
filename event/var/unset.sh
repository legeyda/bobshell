
shelduck import ../../base.sh
shelduck import ../fire.sh

# fun: bobshell_event_var_set VAR
bobshell_event_var_unset() {
	if ! bobshell_isset "$1"; then
		return
	fi
	bobshell_event_fire "_bobshell_event_var_${1}_event"
}

