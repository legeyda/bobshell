
shelduck import ./resource/copy.sh
shelduck import ./locator/is_file.sh

bobshell_eval() {
	if ! bobshell_locator_parse "$1" _bobshell_eval__type _bobshell_eval__ref; then
		_bobshell_eval__type=val
		_bobshell_eval__ref="$1"
	fi
	
	if [ file = "$_bobshell_eval__type" ]; then
		shift
		_bobshell_eval__ref=$(realpath "$_bobshell_eval__ref")
		. "$_bobshell_eval__ref" "$@"
	elif [ val = "$_bobshell_eval__type" ]; then
		shift
		eval "$_bobshell_eval__ref"
	else
		bobshell_resource_copy "$1" var:__bobshell_eval__script
		shift
		eval "$__bobshell_eval__script"
		unset __bobshell_eval__script
	fi

	unset _bobshell_eval__type _bobshell_eval__ref
}