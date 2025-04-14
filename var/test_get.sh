
shelduck import ../assert.sh
shelduck import get.sh
shelduck import ../result/check.sh
shelduck import ../string.sh

test_get() {
	unset x y
	bobshell_var_get x
	assert_error bobshell_result_check y
	assert_unset y

	x=1
	unset y
	bobshell_var_get x
	assert_ok bobshell_result_check y
	assert_isset y
	assert_equals 1 "$y"

	unset y
	bobshell_var_get bobshell_newline
	assert_ok bobshell_result_check y
	assert_isset y
	assert_equals "$bobshell_newline" "$y"



}
