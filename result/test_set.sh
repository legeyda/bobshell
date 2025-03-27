


shelduck import ../assert.sh
shelduck import ./set.sh


test_empty() {
	bobshell_result_set
	assert_equals 0 "$bobshell_result_size"
	assert_unset bobshell_result_1
}

test_one() {
	bobshell_result_set one
	assert_equals 1 "$bobshell_result_size"
	assert_equals one "$bobshell_result_1"
	assert_unset bobshell_result_2
}

test_nine() {
	bobshell_result_set 1 2 3 4 5 6 7 8 9
	assert_equals 9 "$bobshell_result_size"
	assert_equals 1 "$bobshell_result_1"
	assert_equals 2 "$bobshell_result_2"
	assert_equals 3 "$bobshell_result_3"
	assert_equals 4 "$bobshell_result_4"
	assert_equals 5 "$bobshell_result_5"
	assert_equals 6 "$bobshell_result_6"
	assert_equals 7 "$bobshell_result_7"
	assert_equals 8 "$bobshell_result_8"
	assert_equals 9 "$bobshell_result_9"
}

test_ten() {
	bobshell_result_set 1 2 3 4 5 6 7 8 9 10
	assert_equals 10 "$bobshell_result_size"
	assert_equals  1 "$bobshell_result_1"
	assert_equals  2 "$bobshell_result_2"
	assert_equals  3 "$bobshell_result_3"
	assert_equals  4 "$bobshell_result_4"
	assert_equals  5 "$bobshell_result_5"
	assert_equals  6 "$bobshell_result_6"
	assert_equals  7 "$bobshell_result_7"
	assert_equals  8 "$bobshell_result_8"
	assert_equals  9 "$bobshell_result_9"
	assert_equals 10 "$bobshell_result_10"
}
