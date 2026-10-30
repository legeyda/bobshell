
shelduck import ../assert.sh
shelduck import ./lstrip.sh
shelduck import ../result/unset.sh


test_1() {
	bobshell_str_lstrip '
			hello world " \ $ !   			'

	assert_result_equals '
			' 'hello world " \ $ !   			'
}

test_2() {
	bobshell_str_lstrip '
			   			'

	assert_result_equals '
			   			' ''
}

test_3() {
	bobshell_str_lstrip abcabaabxyzabbca '[abc]'
	assert_result_equals abcabaab xyzabbca
}

test_4() {
	bobshell_str_lstrip ' abc ' ' '

	assert_result_equals ' ' 'abc '
}
