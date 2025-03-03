



shelduck import ../assert.sh
shelduck import ./eqvar.sh



test_eqvar() {
	a=1
	b=1
	c=2
	unset d e

	assert_ok    bobshell_eqvar a b
	assert_error bobshell_eqvar a c
	assert_error bobshell_eqvar a d
	assert_error bobshell_eqvar d c
	assert_ok    bobshell_eqvar d e
}