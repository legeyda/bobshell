
shelduck import ../assert.sh
shelduck import set.sh
shelduck import ../result/check.sh
shelduck import ../string.sh

test_set() {
	unset x
	bobshell_var_set x hello
	assert_isset x
	assert_equals hello "$x"

	unset x
	bobshell_var_set x "$bobshell_newline"
	assert_isset x
	assert_equals "$bobshell_newline" "$x"
}
