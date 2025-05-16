
shelduck import ../assert.sh
shelduck import ./get.sh
shelduck import ./put.sh
shelduck import ./unset.sh

test_all() {
	bobshell_map_get M 1
	assert_error bobshell_result_check

	bobshell_map_put M 1 one
	bobshell_map_get M 1
	assert_ok bobshell_result_check x
	assert_equals one "$x"

	bobshell_map_put M 1 uno
	bobshell_map_get M 1
	assert_ok bobshell_result_check x
	assert_equals uno "$x"

	bobshell_map_unset M
	bobshell_map_get M 1
	assert_error bobshell_result_check
}
