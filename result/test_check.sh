


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./check.sh


test_undefined() {
	assert_die bobshell_result_check
}

test_empty() {
	bobshell_result_set
	assert_die bobshell_result_check
}


test_check() {
	bobshell_result_set true
	bobshell_result_check
	bobshell_result_set false
	assert_error bobshell_result_check

	bobshell_result_set true 1 2 3
	bobshell_result_check
	bobshell_result_set false 1 2 3
	assert_error bobshell_result_check

}