


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./foreach.sh

test_foreach_undefined() {
	assert_die bobshell_array_foreach myarr xyz
	assert_equals '' "$(bobshell_array_foreach myarr xyz)"
}

test_foreach_empty() {
	bobshell_array_set myarr
	assert_ok bobshell_array_foreach myarr true
	assert_equals '' "$(bobshell_array_foreach myarr printf '%s ')"
}

test_foreach_not_empty() {
	bobshell_array_set myarr one two three
	assert_equals 'one 1 two 2 three 3 ' "$(bobshell_array_foreach myarr printf '%s ')"
}

test_break() {
	bobshell_array_set myarr one two three
	assert_equals 'one 1 ' "$(bobshell_array_foreach myarr f)"
}

f() {
	printf '%s ' "$@"
	bobshell_result_set break
}
