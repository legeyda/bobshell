

shelduck import ../base.sh
shelduck import ../resource/copy.sh
shelduck import ../locator/is_stdin.sh
shelduck import ../locator/is_stdout.sh


# fun: bobshell_redirect_input INPUT COMMAND [ARGS...]
bobshell_redirect_input() {
	if bobshell_locator_is_stdin "$1"; then
		"$@"
	elif bobshell_locator_is_file "$1" _bobshell_redirect_input__file; then
		shift
		"$@" < "$_bobshell_redirect_input__file"
		unset _bobshell_redirect_input__file
	else
		_bobshell_redirect_input__locator="$1"
		shift
		bobshell_resource_copy "$_bobshell_redirect_input__locator" stdout: | "$@"
		unset _bobshell_redirect_input__locator
	fi
}