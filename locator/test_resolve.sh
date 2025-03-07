shelduck import ../assert.sh
shelduck import ./resolve.sh

test_resolve() {
	x=$(bobshell_locator_resolve file:x)
	assert_equals "file://$(pwd)/x" "$x"

}