


shelduck import ../assert.sh
shelduck import ./defun.sh


test_defun() {
	code=$(bobshell_code_defun f x=1 y=2 z=3 )
	eval "$code"
	unset x y z
	f
	assert_equals 1 "$x"
	assert_equals 2 "$y"
	assert_equals 3 "$z"
}