
shelduck import ../assert.sh
shelduck import ./match.sh

test_regex_match() {
	
	assert_ok bobshell_regex_match 123 '[[:digit:]]\+'
	assert_error bobshell_regex_match blabla '[[:digit:]]\+'

	assert_error bobshell_regex_match hello 'x.*'
	assert_ok bobshell_regex_match hello 'h.*'
	assert_error bobshell_regex_match hello 'los$'
	assert_error bobshell_regex_match hello 'lo$'
	assert_ok bobshell_regex_match hello '.*lo$'
	assert_ok bobshell_regex_match hello '^.*lo$'
	assert_ok bobshell_regex_match 123 '[0-9]\+'

	assert_ok  bobshell_regex_match hello.AppImage '^.*\.AppImage$'
	assert_ok  bobshell_regex_match d5727d84ac69a0235ebef74b26577f190c7ec8321d5612182c210886f7a8fc8a '^[0-9a-f]\{64\}*$'
	


	assert_ok bobshell_regex_match '  shelduck   import   blabla\n' '^\s*shelduck\s\+import\s\+.*$'
	#assert_ok bobshell_regex_match "$bobshell_newline" '^\n.*$'
}


test_1() {
	assert_ok bobshell_regex_match -W '-W\|-x$'
}

test_regex_var() {
	assert_ok    bobshell_regex_match x '[A-Za-z_][A-Za-z_0-9]*'
	assert_error bobshell_regex_match 1 '[A-Za-z_][A-Za-z_0-9]*'
	
}

test_arg_var() {

	assert_ok    bobshell_regex_match 'x-y' '[A-Za-z_0-9-]\+'
	assert_error bobshell_regex_match x/y '[A-Za-z_0-9-]\+'
	# assert_error bobshell_regex_match 1 '[A-Za-z_0-9-]+'
	
}