
shelduck import ../assert.sh
shelduck import ./suffix.sh
shelduck import ../result/unset.sh
shelduck import ../result/assert.sh

test_suffix() {
	bobshell_str_suffix abc ''
	bobshell_result_assert

	bobshell_str_suffix abc c
	bobshell_result_assert

	bobshell_str_suffix '' ''
	bobshell_result_assert

	bobshell_str_suffix abc c
	bobshell_result_assert

	bobshell_str_suffix '' c
	assert_error bobshell_result_check


	bobshell_str_suffix bca b
	assert_error bobshell_result_check



}
