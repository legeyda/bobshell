


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./remove.sh
shelduck import ./foreach.sh

test_undefined() {
	assert_die bobshell_array_remove
	assert_die bobshell_array_remove myarr
	assert_die bobshell_array_remove myarr 1
	assert_die bobshell_array_remove myarr 1 one
	assert_die bobshell_array_remove myarr 0 
	assert_die bobshell_array_remove myarr 0 zero
	assert_die bobshell_array_remove myarr 2 
	assert_die bobshell_array_remove myarr 2 two
}

test_empty() {
	bobshell_array_set myarr

	assert_die bobshell_array_remove
	assert_die bobshell_array_remove myarr
	assert_die bobshell_array_remove myarr 1
	assert_die bobshell_array_remove myarr 1 one
	assert_die bobshell_array_remove myarr 0
	assert_die bobshell_array_remove myarr 0 zero
	assert_die bobshell_array_remove myarr 2 
	assert_die bobshell_array_remove myarr 2 two

}

test_one() {
	bobshell_array_set myarr one
	assert_die bobshell_array_remove myarr 0
	assert_die bobshell_array_remove myarr 0 zero
	assert_die bobshell_array_remove myarr 2 
	assert_die bobshell_array_remove myarr 2 two

	bobshell_array_remove myarr 1
	assert_equals '' "$(bobshell_array_foreach myarr printf '%s ')"
}


test_many() {
	bobshell_array_set myarr one two three
	assert_die bobshell_array_remove myarr 0
	assert_die bobshell_array_remove myarr 0 zero
	assert_die bobshell_array_remove myarr 4 
	assert_die bobshell_array_remove myarr 4 four

	bobshell_array_remove myarr 1
	assert_equals 'two three ' "$(bobshell_array_foreach myarr printf '%s ')"

	bobshell_array_remove myarr 2
	assert_equals 'two ' "$(bobshell_array_foreach myarr printf '%s ')"

}