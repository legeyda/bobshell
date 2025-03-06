


shelduck import ../assert.sh
shelduck import ./assert.sh
shelduck import ./check.sh
shelduck import ./error.sh
shelduck import ./get.sh
shelduck import ./ok.sh


test_result() {
	bobshell_result_ok result value
	assert_ok bobshell_result_assert
	assert_equals 'result value' "$(bobshell_result_get)"

	bobshell_result_error error message
	assert_error bobshell_result_check
	assert_equals 'error message' "$bobshell_result_message"

}
