


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./pop.sh
shelduck import ./push.sh
shelduck import ../array/foreach.sh

test_undefined() {
	assert_die bobshell_stack_pop
	assert_die bobshell_stack_pop mystack
	assert_die bobshell_stack_pop mystack var
}

test_empty() {
	bobshell_stack_set mystack

	assert_die bobshell_stack_pop
	assert_die bobshell_stack_pop mystack
	assert_die bobshell_stack_pop mystack var

}

test_one() {
	bobshell_stack_set mystack
	bobshell_stack_push mystack one

	unset x
	bobshell_stack_pop mystack x
	assert_equals one "$x"

	assert_die bobshell_stack_pop
}


test_many() {
	bobshell_stack_set mystack one two three
	bobshell_stack_push mystack one
	bobshell_stack_push mystack two
	bobshell_stack_push mystack three

	unset x
	bobshell_stack_pop mystack x
	assert_equals three "$x"

	unset x
	bobshell_stack_pop mystack x
	assert_equals two "$x"

	unset x
	bobshell_stack_pop mystack x
	assert_equals one "$x"
	
	assert_die bobshell_stack_pop

}