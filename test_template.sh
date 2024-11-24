

shelduck import assert.sh
shelduck import template.sh


test_interpolate() {
	X=hello
	interpolate_result=
	bobshell_interpolate 'val:${X}:1' var:interpolate_result
	assert_equals 'hello:1' "$interpolate_result"
}

# 
test_mustache() {
	template='hello, {{      name}}, greetings!'
	name=bob

	bobshell_mustache var:template var:output
	assert_equals 'hello, bob, greetings!' "$output"
}


# 
test_mustache_scope() {
	template='hello, {{  name }}, message is: {{   msg}}!'
	x_name=bob
	x_msg='secret message'

	bobshell_mustache -s x_  var:template var:output
	assert_equals 'hello, bob, message is: secret message!' "$output"
}
