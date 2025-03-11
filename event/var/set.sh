
shelduck import ../../base.sh
shelduck import ../fire.sh

# bobshell_event_var_apply hoid_target printf %s
# bobshell_resource_copy var:hoid_target cmd:printfs %s
# use: bobshell_apply hoid_target bobshell_event_var_set 
# fun: bobshell_event_var_set DESTVAR [VALUE]
bobshell_event_var_set() {
	if bobshell_isset_2 "$@"; then
		if bobshell_isset "$1"; then
			_hoid_var_set__value=$(bobshell_getvar "$1")
			if [ "$_hoid_var_set__value" = "$2" ]; then
				unset _hoid_var_set__value
				return
			fi
			unset _hoid_var_set__value
		fi
		bobshell_putvar "$1" "$2"
	else
		if ! bobshell_isset "$1"; then
			return
		fi
		unset "$1"
	fi
	_bobshell_event_var_set__event=$1
	shift	
	bobshell_event_fire "_bobshell_event_var_${_bobshell_event_var_set__event}_event" "$@"
	unset _bobshell_event_var_set__event
}

