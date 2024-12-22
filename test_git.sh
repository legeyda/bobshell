

shelduck import -a die base.sh
shelduck import assert.sh
shelduck import git.sh

test_git_version() {
	init_repo
	assert_error bobshell_git_version --release

	git tag -a hello -m msg
	assert_error bobshell_git_version --release

	git tag -d hello
	git tag -a v1.2.3 -m msg
	assert_ok bobshell_git_version --release
	assert_equals 1.2.3 "$(bobshell_git_version --release)"

}

test_git_is_clean() {
	init_repo
	assert_ok bobshell_git_is_clean

	touch newfile
	git diff HEAD

	printf hello > newfile
	git diff HEAD
	assert_error bobshell_git_is_clean
}

test_git_change_hash() {
	init_repo
	assert_equals 'e69de29bb2d1d6434b8b29ae775ad8c2e48c5391' $(bobshell_git_change_hash)

	touch newfile
	assert_equals 'e69de29bb2d1d6434b8b29ae775ad8c2e48c5391' $(bobshell_git_change_hash)

}


test_git() {
	mkcd target/test-git
	rm -rf ./* ./.git
	which git
	#bobshell_git clone git@github.com:legeyda/bobshell.git .

	#die debug
}


test_branch_version() {
	init_repo

	version=$(bobshell_git_version)
	#assert_equals 75f24966 "$version"



}

test_tag_version() {
	init_repo
	git tag v1.2.3
	

	version=$(bobshell_git_version)
	assert_equals v1.2.3 "$version"


}

clean_repo() {
	mkcd target/test-git
	rm -rf ./* ./.git
}

init_repo() {
	# clean
	clean_repo

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

test_git_auth() {
	clean_repo
	BOBSHELL_SSH_KNOWN_HOSTS=$(ssh_keyscan github.com)
	bobshell_git clone git@github.com:legeyda/bobshell.git .
	




}

ssh_keyscan() {
	for bobshell_ssh_keyscan_host in "$@"; do
		bobshell_ssh_keyscan_addr=$(dig +short "$bobshell_ssh_keyscan_host")
		set -- "$@" "$bobshell_ssh_keyscan_addr"
	done
	unset bobshell_ssh_keyscan_host bobshell_ssh_keyscan_addr
	ssh-keyscan "$@"
}