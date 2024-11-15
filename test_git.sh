

shelduck import base.sh
shelduck import assert.sh



test_branch_version() {
	mkcd target/test-git
	rm -rf ./* ./.git
	init_repo

	version=$(git_version)
	#assert_equals 75f24966 "$version"



}

test_tag_version() {
	mkcd target/test-git
	rm -rf ./* ./.git
	init_repo
	git tag v1.2.3
	

	version=$(git_version)
	assert_equals v1.2.3 "$version"


}

git_version() {
	git describe --tags --abbrev=8 --always --dirty --broken
}

init_repo() {
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



mkcd() {
	mkdir -p "$1"
	cd "$1"
}
