
shelduck import ../assert.sh
shelduck import ./io.sh

test_io() {
	mkdir -p target
	bobshell_redirect_io val:123 file:target/test_io.txt cat
	assert_equals 123 $(cat target/test_io.txt)
}