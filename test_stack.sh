

shelduck import assert.sh
shelduck import stack.sh

test_stack() {
	assert_error bobshell_stack_pop mystack

	bobshell_stack_push mystack1 first
	bobshell_stack_pop mystack1 value; assert_equals first  "$value"
	assert_error bobshell_stack_pop mystack1

	bobshell_stack_push mystack2 first
	bobshell_stack_push mystack2 second
	bobshell_stack_pop mystack2 value; assert_equals second "$value"
	bobshell_stack_pop mystack2 value; assert_equals first  "$value"
	assert_error bobshell_stack_pop mystack2

	bobshell_stack_push mystack2 first
	bobshell_stack_push mystack2 second
	bobshell_stack_push mystack2 third
	bobshell_stack_pop mystack2 value; assert_equals third "$value"
	bobshell_stack_pop mystack2 value; assert_equals second "$value"
	bobshell_stack_pop mystack2 value; assert_equals first  "$value"
	assert_error bobshell_stack_pop mystack3
}