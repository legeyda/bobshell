shelduck import ../string.sh

bobshell_locator_is_writable() {
	bobshell_starts_with "$1" var: eval: stdout: file: /
}