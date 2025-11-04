


shelduck import ../assert.sh
shelduck import ./unset.sh
shelduck import ./set.sh
shelduck import ./insert.sh


test_unset() {
	bobshell_result_unset
	assert_die bobshell_result_insert 1 item
}




test_empty_0() {
	bobshell_result_set
	assert_die bobshell_result_insert
	assert_die bobshell_result_insert 0
	assert_die bobshell_result_insert 2
	bobshell_result_insert 1
	assert_equals 0 "$bobshell_result_size"
}

test_empty_1() {
	bobshell_result_set
	assert_die bobshell_result_insert
	assert_die bobshell_result_insert 0
	assert_die bobshell_result_insert 2
	bobshell_result_insert 1 item
	assert_equals 1 "$bobshell_result_size"
	assert_equals item "$bobshell_result_1"
}

test_empty_2() {
	bobshell_result_set
	assert_die bobshell_result_insert
	assert_die bobshell_result_insert 0
	assert_die bobshell_result_insert 2
	bobshell_result_insert 1 one two
	assert_equals 2 "$bobshell_result_size"
	assert_equals one "$bobshell_result_1"
	assert_equals two "$bobshell_result_2"
}





test_single_1_0() {
	bobshell_result_set init
	assert_die bobshell_result_insert
	assert_die bobshell_result_insert 0
	assert_die bobshell_result_insert 3
	bobshell_result_insert 1
	assert_equals 1    "$bobshell_result_size"
	assert_equals init "$bobshell_result_1"
}

test_single_1_1() {
	bobshell_result_set init
	assert_die bobshell_result_insert
	assert_die bobshell_result_insert 0
	assert_die bobshell_result_insert 3
	bobshell_result_insert 1 more
	assert_equals 2 "$bobshell_result_size"
	assert_equals more "$bobshell_result_1"
	assert_equals init "$bobshell_result_2"
}

test_single_1_2() {
	bobshell_result_set init
	assert_die bobshell_result_insert
	assert_die bobshell_result_insert 0
	assert_die bobshell_result_insert 3
	bobshell_result_insert 1 more aaa
	assert_equals 3 "$bobshell_result_size"
	assert_equals more "$bobshell_result_1"
	assert_equals aaa  "$bobshell_result_2"
	assert_equals init "$bobshell_result_3"
}





test_single_2_0() {
	bobshell_result_set init
	assert_die bobshell_result_insert
	assert_die bobshell_result_insert 0
	assert_die bobshell_result_insert 3
	bobshell_result_insert 2
	assert_equals 1    "$bobshell_result_size"
	assert_equals init "$bobshell_result_1"
}

test_single_2_1() {
	bobshell_result_set init
	assert_die bobshell_result_insert
	assert_die bobshell_result_insert 0
	assert_die bobshell_result_insert 3
	bobshell_result_insert 2 more
	assert_equals 2 "$bobshell_result_size"
	assert_equals init "$bobshell_result_1"
	assert_equals more "$bobshell_result_2"
}

test_single_2_2() {
	bobshell_result_set init
	assert_die bobshell_result_insert
	assert_die bobshell_result_insert 0
	assert_die bobshell_result_insert 3
	bobshell_result_insert 2 more aaa
	assert_equals 3 "$bobshell_result_size"
	assert_equals init "$bobshell_result_1"
	assert_equals more "$bobshell_result_2"
	assert_equals aaa  "$bobshell_result_3"
}