

shelduck import ../base.sh
shelduck import ../resource/copy.sh
shelduck import ../locator/is_stdin.sh
shelduck import ../locator/is_stdout.sh
shelduck import ../locator/is_val.sh
shelduck import ../locator/is_file.sh
shelduck import ../event/listen.sh

bobshell_event_listen bobshell_error_exit_event bobshell_redirect_input_exit_event_listener
bobshell_redirect_input_exit_event_listener() {
	if bobshell_isset bobshell_redirect_input_dd_pid; then
		echo 'exit event: kill dd' >&2
		kill "$bobshell_redirect_input_dd_pid"
	fi
}

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
		_bobshell_redirect_input__temp=$(mktemp -d) # todo common temp dir for all would be more performant
		chmod u+rwx "$_bobshell_redirect_input__temp"
		mkfifo "$_bobshell_redirect_input__temp/1" "$_bobshell_redirect_input__temp/2"
		dd "if=$_bobshell_redirect_input__temp/1" "of=$_bobshell_redirect_input__temp/2" status=none &
		bobshell_redirect_input_dd_pid=$!
		bobshell_resource_copy "$1" "$_bobshell_redirect_input__temp/1"
		shift
		unset bobshell_redirect_input_dd_pid
		"$@" < "$_bobshell_redirect_input__temp/2"
		rm -rf "$_bobshell_redirect_input__temp"
		unset _bobshell_redirect_input__temp
	fi
}