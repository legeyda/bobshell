
shelduck import ../array/remove.sh
shelduck import ../array/read.sh


# fun: bobshell_stack_push STACKNAME [VARNAME]
bobshell_stack_pop() {
	_bobshell_stack_pop__size=$(bobshell_array_size "$1")
	if ! [ 0 -lt "$_bobshell_stack_pop__size" ]; then
		return 1
	fi

	bobshell_array_read "$1" "$_bobshell_stack_pop__size" "$2"
	bobshell_array_remove "$1" "$_bobshell_stack_pop__size"
	unset _bobshell_stack_pop__size

}
