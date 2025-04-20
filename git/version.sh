



shelduck import ../git/tag.sh
shelduck import ../git/branch.sh

shelduck import ../result/set.sh
shelduck import ../result/check.sh
shelduck import ../result/assert.sh

bobshell_git_version() {
	bobshell_git_tag
	if bobshell_result_check && bobshell_remove_prefix "$bobshell_result_2" v bobshell_result_2; then
		return
	fi

	bobshell_git_branch
	bobshell_result_check

	#bobshell_remove_prefix "$bobshell_result_2" feature/ bobshell_result_2 || true
	bobshell_result_2=$(bobshell_replace "$bobshell_result_2" / .)
	bobshell_result_2="${bobshell_result_2}-SNAPSHOT"
}