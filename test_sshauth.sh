

shelduck sshauth.sh
shelduck assert.sh
shelduck string.sh

test_sshauth() {
	 
	result="$(BOBSHELL_SSH_KNOWN_HOSTS_FILE=abc bobshell_sshauth bobshell_quote)"
	assert_equals 'hello' "$result" 
}


