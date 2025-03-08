
shelduck import ../string.sh

# fun: bobshell_resource_is_appendable LOCATOR
bobshell_locator_is_appendable() {
	bobshell_starts_with "$1" var: stdout: file: /
}