
shelduck import ../assert.sh
shelduck import ./listen.sh
shelduck import ./fire.sh
shelduck import ./template.sh



test_fire() {
	unset -f myevent

	bobshell_event_listen myevent 'printf 1'
	assert_equals 1 "$(bobshell_event_fire myevent)"

	bobshell_event_listen myevent 'printf 2'
	assert_equals 12 "$(bobshell_event_fire myevent)"

	bobshell_event_listen myevent 'printf 3'
	assert_equals 123 "$(bobshell_event_fire myevent)"
}

test_template() {
	unset -f myevent
	
	bobshell_event_listen myevent 'printf 1'
	bobshell_event_listen myevent 'printf 2'
	bobshell_event_listen myevent 'printf 3'

	bobshell_event_template myevent 'printf [; {}; printf ]'
	assert_equals '[123]' "$(bobshell_event_fire myevent)"
}