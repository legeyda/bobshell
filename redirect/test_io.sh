
shelduck import ../assert.sh
shelduck import ./io.sh

test_io() {
	mkdir -p target

	unset f
	bobshell_redirect_io val:123 file:target/test_io.txt f
	assert_equals 123 $(cat target/test_io.txt)
	assert_isset f

	unset x f
	bobshell_redirect_io file:target/test_io.txt var:x f 
	assert_equals 123 "$x"
	assert_isset f

	x=$(bobshell_redirect_io file:target/test_io.txt stdout: f)
	assert_equals 123 "$x" 
}

f() {
	f=true
	sleep 1
	cat
}