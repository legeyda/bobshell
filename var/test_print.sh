
shelduck import ../assert.sh
shelduck import print.sh
shelduck import ../result/check.sh
shelduck import ../string.sh

test_get() {
	unset x
	assert_error eval '$(bobshell_var_print x)'
	assert_unset x
	assert_unset y

	x=1
	unset r
	assert_ok eval 'r=$(bobshell_var_print x)'
	assert_isset r
	assert_equals 1 "$r"

	unset r
	assert_ok eval 'r=$(bobshell_var_print bobshell_newline; printf z)'
	assert_isset r
	assert_equals "${bobshell_newline}z" "$r"



}
