



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
		# use https://stackoverflow.com/a/21635000 hack to avoid subshells
		_bobshell_redirect_output="$1"
		shift
		_bobshell_redirect_output__temp=$(mktemp -d)
		mkfifo "$_bobshell_redirect_output__temp/1" "$_bobshell_redirect_output__temp/2"
		unlink "$_bobshell_redirect_output__temp/1"
		unlink "$_bobshell_redirect_output__temp/2"
		dd "if=$_bobshell_redirect_output__temp/1" "of=$_bobshell_redirect_output__temp/2" &
		"$@" > "$_bobshell_redirect_output__temp/1"
		bobshell_resource_copy "file://$_bobshell_redirect_output__temp/2" "$_bobshell_redirect_output"
		rm -rf "$_bobshell_redirect_output__temp"
		unset _bobshell_redirect_output__temp _bobshell_redirect_output
	fi
}