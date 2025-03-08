

shelduck import ../string.sh

bobshell_locator_is_stdin() {
	#set -- bobshell_remove_prefix "$1" stdin:
	bobshell_remove_prefix "$1" stdin: "${2:-}"
}