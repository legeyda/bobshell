
shelduck import ../resource/copy.sh
shelduck import ../string.sh

# fun: bobshell_locator_as_file LOCATOR
bobshell_resource_as_file() {
	if bobshell_starts_with "$1" "file:" _bobshell_resource_as_file__ref; then
		copy_resource var:_bobshell_resource_as_file__ref "$2"
	else
		# shellcheck disable=SC2034
		_bobshell_resource_as_file__result="$(mktemp)"
		copy_resource "$1" "file:$_bobshell_resource_as_file__result"
		copy_resource var:_bobshell_resource_as_file__result "$2"
		unset _bobshell_resource_as_file__result
	fi
	unset _bobshell_resource_as_file__ref
}