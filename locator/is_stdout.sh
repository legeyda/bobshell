

shelduck import ../string.sh

bobshell_locator_is_stdout() {
	bobshell_remove_prefix "$1" stdout: "${2:-}"
}