



shelduck import ../assert.sh
shelduck import ./mktemp.sh
shelduck import ../result/check.sh



test_mktemp() {

	bobshell_mktemp
	bobshell_result_assert tmp1
	assert_file_exists "$tmp1"

	bobshell_mktemp
	bobshell_result_assert tmp2
	assert_file_exists "$tmp2"

	assert_not_equals "$tmp1" "$tmp2"

}

test_mktemp_dir() {

	bobshell_mktemp -d
	bobshell_result_assert tmp1
	assert_ok test -d "$tmp1"

	bobshell_mktemp -d
	bobshell_result_assert tmp2
	assert_ok test -d "$tmp2"

	assert_not_equals "$tmp1" "$tmp2"





}