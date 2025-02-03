


bobshell_defun() {
	bobshell_defun_name="$1"
	shift
	eval "
$bobshell_defun_name() {
	$*
}
"
	unset bobshell_defun_name
}