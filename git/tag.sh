
shelduck import ../result/set.sh

bobshell_git_tag() {
	if _bobshell_git_tag=$(git describe --exact-match); then
		bobshell_result_set true "$_bobshell_git_tag"
	else
		bobshell_result_set false
	fi
	unset _bobshell_git_tag
}