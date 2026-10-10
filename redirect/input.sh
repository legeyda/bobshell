

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
		_bobshell_redirect_input__temp=$(mktemp) # todo common temp dir for all would be more performant
		bobshell_resource_copy "$1" "file://$_bobshell_redirect_input__temp"
		shift
		"$@" < "$_bobshell_redirect_input__temp"
		rm -f "$_bobshell_redirect_input__temp"
		unset _bobshell_redirect_input__temp
	fi
}


# 		bobshell_str_prefix "$1" var:
# 		if bobshell_result_check _bobshell_redirect_input__var; then
# 			shift
# 			bobshell_str_quote "$@"
# 			eval "$bobshell_result_1"' <<EOF_29f4d9ac341548b8916763cba64b9d6d17dcf8ec46854559904eca7769d39b83
# $(printf %s "$'"$_bobshell_redirect_input__var"'")
# EOF_29f4d9ac341548b8916763cba64b9d6d17dcf8ec46854559904eca7769d39b83'
# 			unset _bobshell_redirect_input__var
# 		else
# 			bobshell_str_prefix "$1" val:
# 			if bobshell_result_check; then
# 				shift
# 				"$@" <<EOF_df6a224c68e84a89b9a6b8cc38e80f427a31e5aa06384ad78f9e6c46557de94c
# $(printf %s "$bobshell_result_2")
# EOF_df6a224c68e84a89b9a6b8cc38e80f427a31e5aa06384ad78f9e6c46557de94c
# 			else
# 				_bobshell_redirect_input__temp=$(mktemp) # todo common temp dir for all would be more performant
# 				bobshell_resource_copy "$1" "file://$_bobshell_redirect_input__temp"
# 				shift
# 				"$@" < "$_bobshell_redirect_input__temp"
# 				rm -f "$_bobshell_redirect_input__temp"
# 				unset _bobshell_redirect_input__temp
# 			fi
# 		fi
