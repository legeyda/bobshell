
shelduck import ../assert.sh
shelduck import ./input.sh

test_input() {
	unset xyz
	# shellcheck disable=SC2016
	assert_equals '1$xyz23' $(bobshell_redirect_input 'val:1$xyz23' cat)
}