
shelduck import ../assert.sh
shelduck import ./output.sh

test_output() {
	unset x y
	bobshell_redirect_output var:x f
	assert_equals 123 "$x"
	assert_equals hello "$y"
}

f() {
	sleep 1
	y=hello
	printf %s 123
}

test_newline() {
	unset x
	bobshell_redirect_output var:x printf '%s\n\n\nzzz' hello
	assert_equals 'hello


zzz' "$x"
}