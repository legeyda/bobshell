

shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./push.sh
shelduck import ../array/foreach.sh


test_undefined() {
	assert_die bobshell_stack_push
	assert_die bobshell_stack_push mystack
	assert_die bobshell_stack_push mystack element
}

test_empty() {
	bobshell_stack_set mystack
	bobshell_stack_push mystack element
	assert_equals 'element 1 ' "$(bobshell_array_foreach mystack printf '%s ')"
}

test_one() {
	bobshell_stack_set mystack one
	assert_die bobshell_stack_push mystack

	bobshell_stack_push mystack two
	assert_equals 'one two ' "$(bobshell_array_foreach mystack printf '%s ')"

}


test_many() {
	bobshell_stack_set mystack one two three
	assert_die bobshell_stack_push mystack

	bobshell_stack_push mystack four
	assert_equals 'one two three four ' "$(bobshell_array_foreach mystack printf '%s ')"

	
}