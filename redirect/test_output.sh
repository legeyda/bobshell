
shelduck import ../assert.sh
shelduck import ./output.sh

test_output() {
	unset x
	bobshell_redirect_output var:x printf %s 123
	assert_equals 123 "$x" 
}