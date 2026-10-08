
shelduck import ../assert.sh
shelduck import ./replace.sh


test_replace() {
	bobshell_str_replace hello ell ELL
	bobshell_result_assert
	assert_equals hELLo "$bobshell_result_2"

	bobshell_str_replace hello x y
	bobshell_result_assert
	assert_equals hello "$bobshell_result_2"

	bobshell_str_replace '' x y
	bobshell_result_assert
	assert_equals '' "$bobshell_result_2"

	bobshell_str_replace hello 'l' ''
	bobshell_result_assert
	assert_equals heo "$bobshell_result_2"

	bobshell_str_replace hello '' x
	assert_error bobshell_result_check

}
