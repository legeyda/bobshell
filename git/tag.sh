
shelduck import ../result/ok.sh
shelduck import ../result/error.sh

bobshell_git_tag() {
	if _bobshell_tag=$(git describe --exact-match); then
		bobshell_result_ok "$_bobshell_tag"
	else
		bobshell_result_error
	fi
	unset _bobshell_tag
}