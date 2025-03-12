
shelduck import ../result/true.sh
shelduck import ../result/false.sh

bobshell_git_tag() {
	if _bobshell_tag=$(git describe --exact-match); then
		bobshell_result_true "$_bobshell_tag"
	else
		bobshell_result_error
	fi
	unset _bobshell_tag
}