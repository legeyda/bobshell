
shelduck import ../array/add.sh

# fun: bobshell_stack_push STACKNAME VALUE
bobshell_stack_push() {
	bobshell_array_add "$@"
}
