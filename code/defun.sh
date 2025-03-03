
bobshell_code_defun() {
	printf '%s() {\n' "$1"
	shift
	printf '%s\n' "$*"
	printf '}'
}