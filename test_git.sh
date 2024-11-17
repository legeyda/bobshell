

shelduck import -a die base.sh
shelduck import assert.sh
shelduck import git.sh


test_git() {
	mkcd target/test-git
	rm -rf ./* ./.git
	which git
	#bobshell_git clone git@github.com:legeyda/bobshell.git .

	#die debug
}


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

test_git_auth() {
	mkcd target/test-git
	rm -rf ./* ./.git
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