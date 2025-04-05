



shelduck import ../base.sh
shelduck import ../resource/copy.sh
shelduck import ../locator/is_stdin.sh
shelduck import ../locator/is_stdout.sh
shelduck import ../locator/is_var.sh
shelduck import ../locator/is_file.sh
shelduck import ../event/listen.sh


bobshell_event_listen bobshell_error_exit_event bobshell_redirect_output_exit_event_listener
bobshell_redirect_output_exit_event_listener() {
	if bobshell_isset bobshell_redirect_output_dd_pid; then
		echo 'exit event: kill dd' >&2
		kill "$bobshell_redirect_output_dd_pid"
	fi
}


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
		dd "if=$_bobshell_redirect_output__temp/1" "of=$_bobshell_redirect_output__temp/2" status=none &
		bobshell_redirect_output_dd_pid=$!
		"$@" > "$_bobshell_redirect_output__temp/1"
		bobshell_resource_copy "file://$_bobshell_redirect_output__temp/2" "$_bobshell_redirect_output"
		unset bobshell_redirect_output_dd_pid
		rm -rf "$_bobshell_redirect_output__temp"
		unset _bobshell_redirect_output__temp _bobshell_redirect_output
	fi
}