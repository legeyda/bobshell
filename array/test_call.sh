


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./call.sh

test_call_undefined() {
	assert_die bobshell_array_call myarr
	assert_die bobshell_array_call myarr printf %s
	assert_equals '' "$(bobshell_array_call myarr xyz)"
}

test_call_empty() {
	bobshell_array_set myarr
	assert_ok bobshell_array_call myarr echo
	assert_die bobshell_array_call myarr printf
	assert_ok bobshell_array_call myarr printf %s
	assert_equals '' "$(bobshell_array_call myarr printf %s)"
}

test_call_not_empty() {
	bobshell_array_set myarr one two three
	assert_equals 'one two three ' "$(bobshell_array_call myarr printf '%s ')"
}