

shelduck import ../string.sh

bobshell_locator_is_stdin() {
	bobshell_remove_prefix "$1" stdin: "${2:-}"
}