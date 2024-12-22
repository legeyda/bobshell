

shelduck import assert.sh
shelduck import ini.sh

sample_file='one=1
 two=2
three=3
 [ hello ]
  four =  4 
five = 5   
 six = 6 
 [ again  ]
seven = 7
 eight   = 8
nine = 9'

test_list_groups() {
	result=$(bobshell_ini_list_groups var:sample_file)
	assert_equals 'hello
again' "$result"
}


# fun: test_list_keys PASSWORD
test_list_keys() {
	result=$(bobshell_ini_list_keys var:sample_file hello)
	assert_equals 'four
five
six' "$result"
}

test_get_value() {
	result=$(bobshell_ini_get_value var:sample_file hello four)
	assert_equals 4 "$result"
}

test_put_value() {
	result=$(bobshell_ini_put_value var:sample_file stdout: hello four fo4ur)
	expected=$(bobshell_replace "$sample_file" '  four =  4 ' 'four=fo4ur')
	assert_equals "$expected" "$result"
}


