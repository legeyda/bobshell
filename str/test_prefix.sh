
shelduck import ../assert.sh
shelduck import ./prefix.sh
shelduck import ../result/unset.sh
shelduck import ../result/assert.sh

test_prefix() {
	bobshell_str_prefix abc ''
	bobshell_result_assert

	bobshell_str_prefix abc a
	bobshell_result_assert

	bobshell_str_prefix '' ''
	bobshell_result_assert

	bobshell_str_prefix abc a
	bobshell_result_assert

	bobshell_str_prefix '' a
	assert_error bobshell_result_check


	bobshell_str_prefix bca a
	assert_error bobshell_result_check



}
