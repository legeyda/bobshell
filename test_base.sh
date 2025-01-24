

shelduck import base.sh
shelduck import assert.sh

test_isset_1() {
	assert_ok bobshell_isset_1 1 2 3
	assert_error bobshell_isset_1
}