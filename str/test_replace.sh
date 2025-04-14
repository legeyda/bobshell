
shelduck import ../assert.sh
shelduck import ./replace.sh


test_replace() {
	bobshell_str_replace hello ell ELL
	assert_equals hELLo "$bobshell_result_1"
}
