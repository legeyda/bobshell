
shelduck import ../base.sh
shelduck import ../string.sh
shelduck import ./compile.sh
shelduck import ../misc/defun.sh

bobshell_event_fire() {
	if ! bobshell_command_available "$1"; then
		bobshell_event_compile "$1"
	fi
	"$@"
}
