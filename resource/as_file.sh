
shelduck import ../resource/copy.sh
shelduck import ../string.sh
shelduck import ../result/check.sh

# fun: bobshell_locator_as_file LOCATOR
bobshell_resource_as_file() {
	bobshell_result_set false
	bobshell_event_fire bobshell_resource_as_file_event "$@"
	if bobshell_result_check; then
		return
	fi
	
	if bobshell_starts_with "$1" "file:" _bobshell_resource_as_file__ref; then
		if [ -e "$_bobshell_resource_as_file__ref" ]; then
			bobshell_result_set true "$_bobshell_resource_as_file__ref"
		else
			bobshell_result_set false
		fi
		unset _bobshell_resource_as_file__ref
	elif bobshell_starts_with "$1" val: var: stdin: file: / http: https: ftp: ftps:; then
		# shellcheck disable=SC2034
		_bobshell_resource_as_file__result="$(mktemp)"
		bobshell_resource_copy "$1" "file:$_bobshell_resource_as_file__result"
		bobshell_result_set true "$_bobshell_resource_as_file__result"
		unset _bobshell_resource_as_file__result
	fi
	bobshell_result_set false
}