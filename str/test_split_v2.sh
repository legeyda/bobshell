
shelduck import ../assert.sh
shelduck import ./split_v2.sh
shelduck import ../result/unset.sh

test_split_v2() {
	bobshell_result_unset
	bobshell_str_split_v2 1.2.3.4 .
	assert_equals 4 "$bobshell_result_size"
	assert_equals 1 "$bobshell_result_1"
	assert_equals 2 "$bobshell_result_2"
	assert_equals 3 "$bobshell_result_3"
	assert_equals 4 "$bobshell_result_4"
	assert_unset bobshell_result_5



	bobshell_result_unset
	bobshell_str_split_v2 1.2.3.4 . 2
	assert_equals 2 "$bobshell_result_size"
	assert_equals 1 "$bobshell_result_1"
	assert_equals 2.3.4 "$bobshell_result_2"
	assert_unset bobshell_result_5


	bobshell_result_unset
	bobshell_str_split_v2 ''
	assert_equals 1 "$bobshell_result_size"
	assert_equals '' "$bobshell_result_1"
	assert_unset bobshell_result_2


	bobshell_result_unset
	bobshell_str_split_v2 '' . 999
	assert_equals 1 "$bobshell_result_size"
	assert_equals '' "$bobshell_result_1"
	assert_unset bobshell_result_2
}