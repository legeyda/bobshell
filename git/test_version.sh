

shelduck import ../assert.sh
shelduck import ./version.sh
shelduck import ../result/check.sh

test_x() {
	bobshell_git_version
	bobshell_result_check
	assert_equals unstable-SNAPSHOT "$bobshell_result_2"
}