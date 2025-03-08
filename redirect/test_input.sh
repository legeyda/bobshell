
shelduck import ../assert.sh
shelduck import ./input.sh

test_input() {
	assert_equals 123 $(bobshell_redirect_input val:123 cat)
}