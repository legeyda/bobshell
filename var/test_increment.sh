
shelduck import ../assert.sh
shelduck import ./increment.sh
shelduck import ../result/check.sh
shelduck import ../string.sh

test_increment() {
	x=1
	bobshell_var_increment x
	assert_equals 2 "$x"
}
