


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./read.sh


test_undefined() {
	assert_die bobshell_result_read x y z
}

test_empty() {
	bobshell_result_set
	assert_die bobshell_result_read x y z
}

test_more() {
	bobshell_result_set 1 2 3
	assert_die bobshell_result_read a b c d
}

test_read() {
	bobshell_result_set 1 2 3
	bobshell_result_read a b c
	assert_equals 1 "$a"
	assert_equals 2 "$b"
	assert_equals 3 "$c"
}