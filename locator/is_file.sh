
shelduck import ../base.sh
shelduck import ../string.sh

# fun: bobshell_is_file LOCATOR [FILEPATHVAR]
bobshell_locator_is_file() {
	if bobshell_starts_with "$1" /; then
		if [ -n "${2:-}" ]; then
			bobshell_putvar "$2" "$1"
		fi
	else
		bobshell_remove_prefix "$1" file: "${2:-}"
	fi
}