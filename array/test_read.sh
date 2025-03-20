


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./read.sh

test_undefined() {
	assert_die bobshell_array_read
	assert_die bobshell_array_read myarr
	assert_die bobshell_array_read myarr 1
}

test_empty() {
	bobshell_array_set myarr
	assert_die bobshell_array_read myarr
	assert_die bobshell_array_read myarr 1
}

test_one() {
	bobshell_array_set myarr element
	assert_die bobshell_array_read myarr
	assert_die bobshell_array_read myarr 0
	assert_die bobshell_array_read myarr 2

	unset x
	bobshell_array_read myarr 1
	bobshell_result_assert x
	assert_equals element "$x"

	unset x
	bobshell_array_read myarr 1
	bobshell_result_assert x
	assert_equals element "$x"
}


test_many() {
	bobshell_array_set myarr one two three
	assert_die bobshell_array_insert myarr 0
	assert_die bobshell_array_insert myarr 0 zero
	assert_die bobshell_array_insert myarr 4 
	assert_die bobshell_array_insert myarr 4 four

	unset x
	bobshell_array_read myarr 1
	bobshell_result_assert x
	assert_equals one "$x"

	unset x
	bobshell_array_read myarr 2
	bobshell_result_assert x
	assert_equals two "$x"

	unset x
	bobshell_array_read myarr 3
	bobshell_result_assert x
	assert_equals three "$x"


}