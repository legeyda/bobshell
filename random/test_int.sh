



shelduck import ../assert.sh
shelduck import ./int.sh
shelduck import ../result/assert.sh

test_random_int() {
	bobshell_random_int
	bobshell_result_assert x

	bobshell_random_int
	bobshell_result_assert y

	assert_not_equals "$x" "$y"
}


