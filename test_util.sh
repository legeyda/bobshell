



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


test_unset_scope() {
	x_y=1
	x_y_z=2
	bobshell_unset_scope x_y
	assert_unset x_y
	assert_unset x_y_z
}

test_copy_scope() {

	bobshell_unset_scope u_
	u_x=1
	u_y=2
	bobshell_unset_scope v_
	v_z=1
	bobshell_copy_scope u_ v_
	assert_equals $u_x 1
	assert_equals $u_y 2
	assert_unset v_z
}