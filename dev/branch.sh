

shelduck import ../base.sh
shelduck import ../result/set.sh

bobshell_dev_branch() {
	if bobshell_isset_1 "$@"; then
		bobshell_die 'bobshell_dev_branch: arguments not supported'
	fi
	if _bobshell_dev_branch__output=$(git branch --show-current 2>&1); then
		bobshell_result_set true "$_bobshell_dev_branch__output"
		unset _bobshell_dev_branch__output
	else
		bobshell_result_set false "$_bobshell_dev_branch__output"
	fi
	unset _bobshell_dev_branch__output
}
