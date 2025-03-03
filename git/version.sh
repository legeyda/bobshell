



shelduck import ../git/tag.sh
shelduck import ../git/branch.sh

shelduck import ../result/ok.sh
shelduck import ../result/check.sh
shelduck import ../result/assert.sh
shelduck import ../result/value.sh

bobshell_git_version() {
	bobshell_git_tag
	if bobshell_result_check && bobshell_remove_prefix "$bobshell_result_value" v bobshell_result_value; then
		return
	fi

	bobshell_git_branch
	bobshell_result_assert 'no error expected'
	_bobshel_semver_git__branch=$(bobshell_result_value)

	bobshell_remove_prefix "$_bobshel_semver_git__branch" feature/ _bobshel_semver_git__branch || true
	_bobshel_semver_git__branch=$(bobshell_replace "$_bobshel_semver_git__branch" / .)

	bobshell_result_ok "${_bobshel_semver_git__branch}-SNAPSHOT"

	unset _bobshel_semver_git__branch
}