
shelduck import ../array/remove.sh
shelduck import ../array/read.sh
shelduck import ../result/assert.sh
shelduck import ../result/set.sh

# fun: bobshell_stack_push STACKNAME [VARNAME]
bobshell_stack_pop() {
	bobshell_array_size "$1"
	bobshell_result_assert _bobshell_stack_pop__size
	
	if ! [ 0 -lt "$_bobshell_stack_pop__size" ]; then
		unset _bobshell_stack_pop__size
		bobshell_result_set false
	fi

	bobshell_array_size "$1"
	bobshell_result_assert _bobshell_stack_pop__size
	bobshell_array_read  "$1" "$_bobshell_stack_pop__size"
	bobshell_result_assert _bobshell_stack_pop__result
	bobshell_array_remove "$1" "$_bobshell_stack_pop__size"
	
	bobshell_result_set true "$_bobshell_stack_pop__result"
	unset _bobshell_stack_pop__size _bobshell_stack_pop__result
}
