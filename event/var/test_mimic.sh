


shelduck import ../../assert.sh
shelduck import ./mimic.sh
shelduck import ./listen.sh

test_mimic() {
	bobshell_event_var_listen y listener

	unset flag
	x=1
	unset y
	bobshell_event_var_mimic y x
	assert_equals 1 "$y"
	assert_equals true "$flag"

	unset flag
	x=2
	y=1
	bobshell_event_var_mimic y x
	assert_equals 2 "$y"
	assert_equals true "$flag"

	unset flag
	unset x
	y=1
	bobshell_event_var_mimic y x
	assert_unset x
	assert_equals true "$flag"
}

listener() {
	flag=true
}
