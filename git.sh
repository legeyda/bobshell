

shelduck import ssh.sh
shelduck import string.sh

bobshell_git() {
	bobshell_git_auth git "$@"
}


bobshell_git_auth() {
	if ! bobshell_isset GIT_SSH_COMMAND; then
		bobshell_git_auth_old_password="${BOBSHELL_SSH_PASSWORD:-}"
		unset BOBSHELL_SSH_PASSWORD
		bobshell_git_auth_command=$(bobshell_ssh_auth bobshell_quote)
		if [ -n "$bobshell_git_auth_command" ]; then
			GIT_SSH_COMMAND=$bobshell_git_auth_command
		fi
		BOBSHELL_SSH_PASSWORD="$bobshell_git_auth_old_password"
	fi
	if bobshell_isset GIT_SSH_COMMAND; then
		export GIT_SSH_COMMAND
	fi
	bobshell_maybe_sshpass "$@"
}

