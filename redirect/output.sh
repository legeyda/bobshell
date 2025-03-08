



shelduck import ../base.sh
shelduck import ../resource/copy.sh
shelduck import ../locator/is_stdin.sh
shelduck import ../locator/is_stdout.sh
shelduck import ../locator/is_var.sh



# fun: bobshell_redirect_output OUTPUT COMMAND [ARGS...]
bobshell_redirect_output() {
	if bobshell_locator_is_stdout "$1"; then
		shift
		"$@"
	elif bobshell_locator_is_file "$1" _bobshell_redirect_output__file; then
		shift
		"$@" > "$_bobshell_redirect_output__file"
		unset _bobshell_redirect_output__file
	elif bobshell_locator_is_var "$1" || bobshell_locator_is_eval "$1"; then
		_bobshell_redirect_output__locator="$1"
		shift
		_bobshell_redirect_output__result=$("$@")
		bobshell_resource_copy var:_bobshell_redirect_output__result "$_bobshell_redirect_output__locator"
		unset _bobshell_redirect_output__locator _bobshell_redirect_output__result
	else
		_bobshell_redirect_output__locator="$1"
		shift
		"$@" | bobshell_resource_copy stdin: "$1"
		unset _bobshell_redirect_output__locator
	fi
}