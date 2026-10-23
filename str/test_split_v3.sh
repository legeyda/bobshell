
shelduck import ../assert.sh
shelduck import ./split_v3.sh
shelduck import ../result/unset.sh


test_1() {
	bobshell_str_split_v3 'a123' a
	assert_result_equals true '' '123'
}

test_2() {

	bobshell_str_split_v3 '123x' x
	assert_result_equals true '123' ''

}

test_3() {


	bobshell_str_split_v3 'shelduck import xyz
''shelduck import abc

blabla' 'shelduck import ' 2
	assert_result_equals true '' 'xyz
''shelduck import abc

blabla'


}

test_4() {



	bobshell_str_split_v3 'hello
newline' '
'
	assert_result_equals true hello newline


}

test_5() {


	bobshell_str_split_v3 hello :

	assert_result_equals false
}
