
shelduck import ../assert.sh
shelduck import ./quote.sh


test_replace() {
	bobshell_replace hello ell ELL
	assert_equals hELLo "$bobshell_result_1"
}
