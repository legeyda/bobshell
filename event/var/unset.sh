
shelduck import ../../base.sh
shelduck import ../fire.sh
shelduck import ./set.sh

# fun: bobshell_event_var_unset VAR
bobshell_event_var_unset() {
	bobshell_event_var_set "$1"
}

