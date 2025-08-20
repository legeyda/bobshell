



shelduck import version.sh
shelduck import ../assert.sh



test_git_status_porcelain() {
	set -- git status --porcelain

	cd "$(mktemp -d)"
	assert_error "$@"
	assert_equals '' "$("$@" 2> /dev/null)"

	prepare_repo
	assert_equals '' "$("$@")"
	touch newfile
	assert_not_equals '' "$("$@")"
}



test_git_describe_exact_match() {
	set -- git describe --exact-match
	prepare_repo
	assert_error "$@"
	git tag leightweight
	assert_error "$@"
	git tag annotated --annotate --message tag-annotation 
	assert_equals annotated $("$@")
}



test_git_describe_exact_match_tags() {
	set -- git describe --tags --exact-match
	
	prepare_repo
	assert_error "$@"
	git tag leightweight
	assert_equals leightweight "$("$@")"

	prepare_repo
	assert_error "$@"
	git tag annotated --annotate --message tag-annotation 
	assert_equals annotated "$("$@")"
}



test_git_branch_show_current() {
	set -- git branch --show-current

	cd "$(mktemp -d)"
	assert_error "$@"

	prepare_repo
	assert_equals main "$("$@")"
}



test_dev_version() {
	cd "$(mktemp -d)"
	bobshell_dev_version
	assert_error bobshell_result_check

	bobshell_dev_version --allow-snapshot
	assert_error bobshell_result_check


	prepare_repo
	bobshell_dev_version
	assert_error bobshell_result_check

	bobshell_dev_version -s
	bobshell_result_check value
	assert_equals main-SNAPSHOT "$value"

	touch newfile
	bobshell_dev_version
	assert_error bobshell_result_check

	bobshell_dev_version --allow-snapshot
	assert_ok bobshell_result_check value
	assert_equals main-SNAPSHOT "$value"

	git add .
	git commit --message=newfile
	git checkout -b release/XYZ
	bobshell_dev_version
	assert_error bobshell_result_check

	bobshell_dev_version --allow-snapshot
	assert_ok bobshell_result_check value
	assert_equals XYZ-SNAPSHOT "$value"


	git tag vxyz
	bobshell_dev_version
	assert_ok bobshell_result_check value
	assert_equals xyz "$value"

	touch onemorefile
	bobshell_dev_version
	assert_error bobshell_result_check

	bobshell_dev_version --allow-snapshot
	assert_ok bobshell_result_check value
	assert_equals xyz-SNAPSHOT "$value"

	git add .
	git commit --message=onemorefile
	git tag noversiontag
	bobshell_dev_version
	assert_error bobshell_result_check

	bobshell_dev_version --allow-snapshot
	assert_ok bobshell_result_check value
	assert_equals XYZ-SNAPSHOT "$value"

	

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

