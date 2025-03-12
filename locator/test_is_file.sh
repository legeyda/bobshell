
shelduck import ../assert.sh
shelduck import ./is_file.sh

test_is_file() {
	unset x
	assert_error bobshell_locator_is_file 1
	assert_unset x

	assert_ok bobshell_locator_is_file /1 x
	assert_equals /1 "$x"

	assert_ok bobshell_locator_is_file file:1 x
	assert_equals 1 "$x"

	assert_ok bobshell_locator_is_file file:/1 x
	assert_equals /1 "$x"
	
	assert_ok bobshell_locator_is_file file://1 x
	assert_equals 1 "$x"

	assert_ok bobshell_locator_is_file file:///1 x
	assert_equals /1 "$x"
}