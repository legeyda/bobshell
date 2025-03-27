


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./insert.sh
shelduck import ./foreach.sh

test_undefined() {
	assert_die bobshell_array_insert
	assert_die bobshell_array_insert myarr
	assert_die bobshell_array_insert myarr 1
	assert_die bobshell_array_insert myarr 1 one
	assert_die bobshell_array_insert myarr 0 
	assert_die bobshell_array_insert myarr 0 zero
	assert_die bobshell_array_insert myarr 2 
	assert_die bobshell_array_insert myarr 2 two
}

test_empty() {
	bobshell_array_set myarr

	assert_die bobshell_array_insert myarr
	assert_die bobshell_array_insert myarr 1
	assert_die bobshell_array_insert myarr 1 one
	assert_die bobshell_array_insert myarr 0
	assert_die bobshell_array_insert myarr 0 zero
	assert_die bobshell_array_insert myarr 2 
	assert_die bobshell_array_insert myarr 2 two

}

test_one() {
	bobshell_array_set myarr one
	assert_die bobshell_array_insert myarr 1
	assert_die bobshell_array_insert myarr 0
	assert_die bobshell_array_insert myarr 0 zero
	assert_die bobshell_array_insert myarr 2 
	assert_die bobshell_array_insert myarr 2 two


	bobshell_array_insert myarr 1 zero
	assert_equals 'zero 1 one 2 ' "$(bobshell_array_foreach myarr printf '%s ')"

}


test_many() {
	bobshell_array_set myarr one two three
	assert_die bobshell_array_insert myarr 0
	assert_die bobshell_array_insert myarr 0 zero
	assert_die bobshell_array_insert myarr 4 
	assert_die bobshell_array_insert myarr 4 four

	bobshell_array_insert myarr 1 hello
	assert_equals 'hello 1 one 2 two 3 three 4 ' "$(bobshell_array_foreach myarr printf '%s ')"

	bobshell_array_insert myarr 3 hi
	assert_equals 'hello 1 one 2 hi 3 two 4 three 5 ' "$(bobshell_array_foreach myarr printf '%s ')"

	bobshell_array_insert myarr 5 xyz
	assert_equals 'hello 1 one 2 hi 3 two 4 xyz 5 three 6 ' "$(bobshell_array_foreach myarr printf '%s ')"
	
}