
shelduck import ../base.sh
shelduck import ../string.sh
shelduck import ../result/set.sh
shelduck import ./compile.sh
shelduck import ../misc/defun.sh
shelduck import ../var/append.sh

bobshell_event_stop() {
	_bobshell_event_stop_flag=true
}
