
shelduck import ../assert.sh
shelduck import ./config.sh
shelduck import ./printf.sh


test_buffer() {
	assert_equals hello $(bobshell_buffer_printf %s hello)
	
	bobshell_buffer_config var:xyz
	bobshell_buffer_printf %s hi
	bobshell_buffer_printf %s ' all'
	
	assert_equals 'hi all' "$xyz"

	bobshell_buffer_config stdout:
	assert_equals 123 $(bobshell_buffer_printf %s 123)
}

test_newline() {
	bobshell_buffer_config var:xyz
	bobshell_buffer_printf '%s\n' hello
	bobshell_buffer_printf '%s\n\nzzz' hi

	assert_equals 'hello
hi

zzz'         "$xyz"
	
}