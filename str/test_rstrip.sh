
shelduck import ../assert.sh
shelduck import ./rstrip.sh
shelduck import ../result/unset.sh


test_1() {
	bobshell_str_rstrip '
			hello world " \ $ !   			'

	assert_result_equals '
			hello world " \ $ !' '   			'
}

test_2() {
	bobshell_str_rstrip '
			   			'

	assert_result_equals '' '
			   			'

}

test_3() {
	bobshell_str_rstrip abcabaabxyzabbca '[abc]'
	assert_result_equals abcabaabxyz abbca
}

test_4() {
	bobshell_str_rstrip ' abc ' ' '

	assert_result_equals ' abc' ' '
}
