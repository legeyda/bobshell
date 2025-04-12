
shelduck import ../../assert.sh
shelduck import ../../result/check.sh
shelduck import join.sh

test_empty() {
	bobshell_str_path_join
	unset x
	assert_error bobshell_result_check x
	assert_unset x
}

test_one() {
	bobshell_str_path_join ///1///
	unset x
	assert_ok bobshell_result_check x
	assert_isset x
	assert_equals ///1/// "$x"
}

test_multi() {
	bobshell_str_path_join //1 2// 3 //4 5//
	unset x
	assert_ok bobshell_result_check x
	assert_isset x
	assert_equals //1/2/3/4/5// "$x"
}