
shelduck import ../result/ok.sh

bobshell_git_branch() {
	_bobshell_git_branch=$(git branch --show-current)
	bobshell_result_ok "$_bobshell_git_branch"
	unset _bobshell_git_branch

}