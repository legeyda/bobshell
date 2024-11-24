

shelduck import assert.sh
shelduck import scope.sh


test_debug() {
	x_y=1
	x_z=2
	bobshell_scope_names x_
	
}

test_scope_names() {
	bobshell_scope_unset x_
	bobshell_scope_unset y_
	
	x_y=1
	x_z=2

	assert_equals '' "$(bobshell_scope_names y_)" 
	assert_equals ' x_y x_z' "$(bobshell_scope_names x_)" 


}

test_scope_unset() {
	x_y=1
	x_y_z=2
	bobshell_scope_unset x_y
	assert_unset x_y
	assert_unset x_y_z
}

test_scope_copy() {

	bobshell_scope_unset u_
	u_x=1
	u_y=2

	bobshell_scope_unset v_
	v_z=1


	bobshell_scope_copy u_ v_
	
	assert_equals 1 "${v_x:-}"
	assert_equals 2 "${v_y:-}"
	assert_unset v_z
}

test_scope_env() {
	bobshell_scope_unset x_
	x_y=1
	x_z=2
	
	str=
	bobshell_scope_env x_ var:str
	assert_equals 'x_y=1
x_z=2
' "$str"

}