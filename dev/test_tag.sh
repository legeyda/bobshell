



shelduck import tag.sh
shelduck import ../result/check.sh
shelduck import ../assert.sh



test_dev_tag() {
	cd "$(mktemp -d)"
	bobshell_dev_tag
	assert_error bobshell_result_check

	prepare_repo
	bobshell_dev_tag
	assert_error bobshell_result_check

	git tag xyz
	bobshell_dev_tag
	assert_ok bobshell_result_check value
	assert_equals xyz "$value"
}



prepare_repo() {
	# temp dir
	_prepare_repo=$(mktemp -d)
	cd "$_prepare_repo"
	unset _prepare_repo

	# init
	git init .
	git config user.name user
	git config user.email user@example.com

	# sample commits
	git checkout -B main
	printf %s hello > file.txt
	git add file.txt
	git commit --message=initial-commit
	
}

