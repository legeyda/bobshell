
shelduck import ../../assert.sh
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


	assert_ok bobshell_regex_match '  shelduck   import   blabla\n' '^\s*shelduck\s\+import\s\+.*$'
	#assert_ok bobshell_regex_match "$bobshell_newline" '^\n.*$'
}
