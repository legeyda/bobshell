


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
	assert_equals 'zero one ' "$(bobshell_array_foreach myarr printf '%s ')"

}


test_many() {
	bobshell_array_set myarr one two three
	assert_die bobshell_array_insert myarr 0
	assert_die bobshell_array_insert myarr 0 zero
	assert_die bobshell_array_insert myarr 4 
	assert_die bobshell_array_insert myarr 4 four

	bobshell_array_insert myarr 1 hello
	assert_equals 'hello one two three ' "$(bobshell_array_foreach myarr printf '%s ')"

	bobshell_array_insert myarr 3 hi
	assert_equals 'hello one hi two three ' "$(bobshell_array_foreach myarr printf '%s ')"

	bobshell_array_insert myarr 5 xyz
	assert_equals 'hello one hi two xyz three ' "$(bobshell_array_foreach myarr printf '%s ')"
	
}