

shelduck import ssh.sh
shelduck import assert.sh
shelduck import string.sh

_test_ssh_auth() {
	 
	result="$(BOBSHELL_SSH_KNOWN_HOSTS_FILE=abc bobshell_sshauth bobshell_quote)"
	assert_equals 'hello' "$result" 
}




fake_git() {
	printf 'GIT_SSH_COMMAND=<%s>' "$GIT_SSH_COMMAND"
	printf ' <%s>' "$@"
}

test_git_auth() {
	result="$(BOBSHELL_SSH_KNOWN_HOSTS_FILE=abc bobshell_git_auth fake_git)"

	assert_equals 'GIT_SSH_COMMAND=< -o UserKnownHostsFile=abc> <>' "$result" 
}