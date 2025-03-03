
shelduck import ../code/defun.sh

bobshell_defun() {
	_bobshell_defun__script=$(bobshell_code_defun "$@")
	eval "$_bobshell_defun__script"
	unset _bobshell_defun__script
}