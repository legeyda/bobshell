

shelduck import ../base.sh
shelduck import ../resource/copy.sh
shelduck import ../locator/is_stdin.sh
shelduck import ../locator/is_stdout.sh
shelduck import ../locator/is_val.sh


# fun: bobshell_redirect_input INPUT COMMAND [ARGS...]
bobshell_redirect_input() {
	if bobshell_locator_is_stdin "$1"; then
		shift
		"$@"
	elif bobshell_locator_is_file "$1" _bobshell_redirect_input__file; then
		shift
		"$@" < "$_bobshell_redirect_input__file"
		unset _bobshell_redirect_input__file
	else
		bobshell_resource_copy "$1" var:_bobshell_redirect_input
		shift
		"$@" <<EOF
$_bobshell_redirect_input
EOF
		unset _bobshell_redirect_input
	fi
}