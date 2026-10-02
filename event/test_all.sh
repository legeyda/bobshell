
shelduck import ../assert.sh
shelduck import ./listen.sh
shelduck import ./fire.sh
shelduck import ./stop.sh
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

test_fire_unknown() {
	bobshell_event_fire blabla
}

test_flag() {
	x=0
	bobshell_event_listen test_flag_evt1 eval x=1
	bobshell_event_fire test_flag_evt1
	assert_equals 1 "$x"

	x=0
	bobshell_event_listen test_flag_evt1 eval 'bobshell_event_fire test_flag_evt1'
	assert_die bobshell_event_fire test_flag_evt1

	x=0
	bobshell_event_listen test_flag_evt2 eval 'x=1; bobshell_event_fire test_flag_evt3'
	bobshell_event_listen test_flag_evt3 eval 'x=2'
	bobshell_event_fire test_flag_evt2
	assert_equals 2 "$x"


}

test_stop() {

	x=0
	bobshell_event_listen test_stop_evt1 eval x=1
	bobshell_event_listen test_stop_evt1 eval x=2
	bobshell_event_listen test_stop_evt1 eval x=3
	bobshell_event_fire test_stop_evt1
	assert_equals 3 "$x"


	x=0
	bobshell_event_listen test_stop_evt2 eval x=1
	bobshell_event_listen test_stop_evt2 eval bobshell_event_stop
	bobshell_event_listen test_stop_evt2 eval x=3
	bobshell_event_fire test_stop_evt2
	assert_equals 1 "$x"


}
