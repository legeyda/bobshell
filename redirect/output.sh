



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
	else
		_bobshell_redirect_output="$1"
		shift
		_bobshell_redirect_output__temp=$(mktemp)
		"$@" > "$_bobshell_redirect_output__temp"
		bobshell_resource_copy "file://$_bobshell_redirect_output__temp" "$_bobshell_redirect_output"
		rm -f "$_bobshell_redirect_output__temp"
		unset bobshell_redirect_output _bobshell_redirect_output__temp
	fi
}