
shelduck import base.sh

# fun: bobshell_stack_push STACKNAME VALUE
bobshell_stack_push() {
	bobshell_stack_size=$(bobshell_stack_size "$1")
	bobshell_stack_size=$(( bobshell_stack_size + 1 ))

	bobshell_putvar "${1}_size" "$bobshell_stack_size"
	bobshell_putvar "${1}_$bobshell_stack_size" "$2"

	unset bobshell_stack_size
}

# fun: bobshell_stack_push STACKNAME VARNAME
bobshell_stack_pop() {
	bobshell_stack_size=$(bobshell_stack_size "$1")
	if [ 0 -eq "$bobshell_stack_size" ]; then
		return 1
	fi

	bobshell_stack_pop_value=$(bobshell_getvar "${1}_$bobshell_stack_size" '')
	unset "${1}_$bobshell_stack_size"
	bobshell_putvar "$2" "$bobshell_stack_pop_value"
	unset bobshell_stack_pop_value

	bobshell_stack_size=$(( bobshell_stack_size - 1 ))
	bobshell_putvar "${1}_size" "$bobshell_stack_size"
	unset bobshell_stack_size
}

bobshell_stack_size() {
	bobshell_getvar "${1}_size" 0
}