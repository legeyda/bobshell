
shelduck import ../assert.sh
shelduck import ./strip.sh
shelduck import ../result/unset.sh


test_1() {
	bobshell_str_strip '
			hello world " \ $ !   			'

	assert_result_equals 'hello world " \ $ !'
}
test_2() {
	bobshell_str_strip '
			   			'

	assert_result_equals ''
}

test_3() {
	bobshell_str_strip abcabaabxyzabbca '[abc]'
	assert_result_equals xyz
}
