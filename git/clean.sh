
bobshell_git_clean() {
	bobshell_git_is_clean_output=$(git status --porcelain)
	test -z "$bobshell_git_is_clean_output"
}