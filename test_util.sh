



shelduck import -a die base.sh
shelduck import util.sh
shelduck import assert.sh


_test_list_var_names() {
	export X='str1'"'"'
str2
str3'


	bobshell_list_var_names | sort
	
	die debug
}

test_preserve_env() {
	x=1
	unset y
	bobshell_preserve_env eval 'x=2; y=2'
	assert_equals 1 "$x"
	assert_equals 2 "$y"
}