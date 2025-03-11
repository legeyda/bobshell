
import ./resource/copy.sh
import ./locator/is_file.sh

bobshell_eval() {
	bobshell_locator parse "$1" _bobshell_eval__type _bobshell_eval__ref
	if [ 'file' = "$_bobshell_eval__type" ]; then
		_bobshell_eval__ref=$(realpath "$_bobshell_eval__ref")
		. "$_bobshell_eval__ref"
	else
		bobshell_resource_copy "$1" var:__bobshell_eval__script
		eval "$__bobshell_eval__script"
		unset __bobshell_eval__script
	fi
}