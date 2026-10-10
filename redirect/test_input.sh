
shelduck import ../assert.sh
shelduck import ./input.sh

#shelduck preprocess replace %%_ bobshell_

test_input() {
	unset xyz
	# shellcheck disable=SC2016
	assert_equals '1$xyz23' $(bobshell_redirect_input 'val:1$xyz23' cat)
}

test_var() {
	x=hello
	bobshell_redirect_input var:x eval 'x=$(cat)'
	assert_equals hello "$x"
}

test_val() {
	bobshell_redirect_input val:hello eval 'x=$(cat)'
	assert_equals hello "$x"
}
