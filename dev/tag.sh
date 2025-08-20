

shelduck import ../base.sh
shelduck import ../result/set.sh

bobshell_dev_tag() {
	if bobshell_isset_1 "$@"; then
		bobshell_die 'bobshell_dev_tag: arguments not supported'
	fi
	if _bobshell_dev_tag__output=$(git describe --exact-match --tags 2>&1); then
		bobshell_result_set true "$_bobshell_dev_tag__output"
		unset _bobshell_dev_tag__output
	else
		bobshell_result_set false "$_bobshell_dev_tag__output"
	fi
	unset _bobshell_dev_tag__output
}
