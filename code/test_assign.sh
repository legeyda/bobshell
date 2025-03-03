


shelduck import ../assert.sh
shelduck import assign.sh

test_assign() {
	x=$(bobshell_code_assign varname varvalue)
	assert_equals "varname='varvalue'" "$x"
}