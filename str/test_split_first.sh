
shelduck import ../assert.sh
shelduck import ./split_first.sh
shelduck import ../result/assert.sh

test_split_first() {
	bobshell_str_split_first 1/2/3 /
	bobshell_result_assert left right
	assert_equals 1 "$left"
	assert_equals 2/3 "$right"
}
