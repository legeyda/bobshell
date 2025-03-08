
shelduck import ../base.sh
shelduck import ../string.sh

# fun: bobshell_is_file LOCATOR [FILEPATHVAR]
bobshell_locator_is_var() {
	bobshell_remove_prefix "$1" var: "${2:-}"
}