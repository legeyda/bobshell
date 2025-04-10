
shelduck import ../assert.sh
shelduck import ./split_last.sh
shelduck import ../result/assert.sh

test_split_last() {
	bobshell_str_split_last 1/2/3 /
	bobshell_result_assert left right
	assert_equals 1/2 "$left"
	assert_equals 3   "$right"
}
