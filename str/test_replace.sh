
shelduck import ../assert.sh
shelduck import ./replace.sh


test_replace() {
	bobshell_str_replace hello ell ELL
	assert_equals hELLo "$bobshell_result_1"

	bobshell_str_replace hello x y
	assert_equals hello "$bobshell_result_1"

	bobshell_str_replace '' x y
	assert_equals '' "$bobshell_result_1"

	bobshell_str_replace hello 'l' ''
	assert_equals heo "$bobshell_result_1"

	bobshell_str_replace hello '' x
	assert_error bobshell_result_check

}
