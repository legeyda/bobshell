shelduck import ../assert.sh
shelduck import ./parse.sh

test_parse() {
	unset test_parse_type test_parse_ref

	bobshell_locator_parse file:1 test_parse_type test_parse_ref
	assert_equals file "$test_parse_type"
	assert_equals 1 "$test_parse_ref"

	bobshell_locator_parse file:/1 test_parse_type test_parse_ref
	assert_equals file "$test_parse_type"
	assert_equals /1 "$test_parse_ref"

	bobshell_locator_parse file://1 test_parse_type test_parse_ref
	assert_equals file "$test_parse_type"
	assert_equals 1 "$test_parse_ref"

	bobshell_locator_parse file:///1 test_parse_type test_parse_ref
	assert_equals file "$test_parse_type"
	assert_equals /1 "$test_parse_ref"


	unset test_parse_type test_parse_ref
	assert_error bobshell_locator_parse blabla: test_parse_type test_parse_ref
	assert_unset test_parse_type
	assert_unset test_parse_type

}