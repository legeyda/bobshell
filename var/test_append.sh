
shelduck import ../assert.sh
shelduck import ./append.sh
shelduck import ../result/check.sh
shelduck import ../string.sh

test_append() {
	unset x
	bobshell_var_append x y
	assert_error bobshell_result_check
	assert_unset x

	x=1
	bobshell_var_append x 2
	assert_equals 12 "$x"
}
