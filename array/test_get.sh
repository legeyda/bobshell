


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./get.sh

test_undefined() {
	assert_die bobshell_array_get
	assert_die bobshell_array_get myarr
	assert_die bobshell_array_get myarr 1
	assert_die bobshell_array_get myarr 1 var
}

test_empty() {
	bobshell_array_set myarr
	assert_die bobshell_array_get myarr
	assert_die bobshell_array_get myarr 1
	assert_die bobshell_array_get myarr 1 var
}

test_one() {
	bobshell_array_set myarr element
	assert_die bobshell_array_get myarr
	assert_die bobshell_array_get myarr 0
	assert_die bobshell_array_get myarr 0 z
	assert_die bobshell_array_get myarr 2
	assert_die bobshell_array_get myarr 2 t

	assert_equals element "$(bobshell_array_get myarr 1)"

	unset x
	bobshell_array_get myarr 1 x
	assert_equals element "$x"
}


test_many() {
	bobshell_array_set myarr one two three
	assert_die bobshell_array_insert myarr 0
	assert_die bobshell_array_insert myarr 0 zero
	assert_die bobshell_array_insert myarr 4 
	assert_die bobshell_array_insert myarr 4 four

	assert_equals one   "$(bobshell_array_get myarr 1)"
	assert_equals two   "$(bobshell_array_get myarr 2)"
	assert_equals three "$(bobshell_array_get myarr 3)"

	unset x
	bobshell_array_get myarr 1 x
	assert_equals one "$x"

	unset x
	bobshell_array_get myarr 2 x
	assert_equals two "$x"

	unset x
	bobshell_array_get myarr 3 x
	assert_equals three "$x"


}