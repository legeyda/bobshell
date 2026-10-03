
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

test_split_v2_b() {
	bobshell_str_split_v2 'a123' a
	assert_equals 2 "$bobshell_result_size"
	assert_equals '' "$bobshell_result_1"
	assert_equals '123' "$bobshell_result_2"

	bobshell_str_split_v2 '123x' x
	assert_equals 2 "$bobshell_result_size"
	assert_equals '123' "$bobshell_result_1"
	assert_equals '' "$bobshell_result_2"

	bobshell_str_split_v2 'shelduck import xyz
''shelduck import abc

blabla' 'shelduck import ' 2
	assert_equals 2 "$bobshell_result_size"
	assert_equals '' "$bobshell_result_1"
	assert_equals 'xyz
''shelduck import abc

blabla' "$bobshell_result_2"

	bobshell_str_split_v2 'hello
newline' '
'

	assert_equals 2 "$bobshell_result_size"
	assert_equals hello "$bobshell_result_1"
	assert_equals newline "$bobshell_result_2"

	bobshell_str_split_v2 hello :
	assert_equals 1 "$bobshell_result_size"
	assert_equals hello "$bobshell_result_1"

}
