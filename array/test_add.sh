


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./add.sh
shelduck import ./foreach.sh

test_undefined() {
	assert_die bobshell_array_add
	assert_die bobshell_array_add myarr
	assert_die bobshell_array_add myarr element
}

test_empty() {
	bobshell_array_set myarr
	bobshell_array_add myarr element
	assert_equals 'element 1 ' "$(bobshell_array_foreach myarr printf '%s ')"
}

test_one() {
	bobshell_array_set myarr one
	assert_die bobshell_array_add myarr

	bobshell_array_add myarr two
	assert_equals 'one 1 two 2 ' "$(bobshell_array_foreach myarr printf '%s ')"

}


test_many() {
	bobshell_array_set myarr one two three
	assert_die bobshell_array_add myarr

	bobshell_array_add myarr four
	assert_equals 'one 1 two 2 three 3 four 4 ' "$(bobshell_array_foreach myarr printf '%s ')"

	
}