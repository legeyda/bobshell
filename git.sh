

shelduck import ssh.sh
shelduck import string.sh

bobshell_git() {
	bobshell_git_ssh_auth git "$@"
}

# bobshell_git_url_is_ssh() {
# 	bobshell_git_url_is_ssh_protocol=$(bobshell_git_get_url_protocol "$@")
# 	test ssh = "$bobshell_git_url_is_ssh_protocol"
# }

# bobshell_git_get_url_protocol() {
# 	if bobshell_starts_with "$1" 'ssh://'; then
# 		printf ssh
# 		return
# 	elif bobshell_starts_with "$1" 'https://'; then
# 		printf https
# 	elif bobshell_starts_with "$1" 'git@' && bobshell_contains "$1" :; then
# 		printf ssh
# 	fi
# 	bobshell_die 'unable to determine url protocol: %s' "$1"
# }


bobshell_git_ssh_auth() {
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

