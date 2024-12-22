

shelduck import ssh.sh
shelduck import string.sh
shelduck import base.sh

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
			GIT_SSH_COMMAND="ssh $bobshell_git_auth_command"
		fi
		BOBSHELL_SSH_PASSWORD="$bobshell_git_auth_old_password"
	fi
	if bobshell_isset GIT_SSH_COMMAND; then
		export GIT_SSH_COMMAND
	fi
	bobshell_maybe_sshpass "$@"
}

bobshell_git_version() {
	bobshell_git_version_release=false
	while bobshell_isset_1 "$@"; do
		case "$1" in
			(-r|--release) bobshell_git_version_release=true ;;
			(*) bobshell_die "bobshell_git_version: unexpected argument: $1"
		esac
		shift
	done
	
	if [ true = "$bobshell_git_version_release" ]; then
		if ! bobshell_git_is_clean; then
			bobshell_printf_stderr 'bobshell_git_version: working folder has local modifications'
			return 1
		fi
		unset bobshell_git_version
		if ! bobshell_git_version=$(bobshell_git_version_if_relase 2> /dev/null) || [ -z "$bobshell_git_version" ]; then
			bobshell_printf_stderr 'bobshell_git_version: no git (annotated) tag, which is required'
			return 1
		fi
		if ! bobshell_remove_prefix "$bobshell_git_version" v bobshell_git_version; then
			bobshell_printf_stderr 'bobshell_git_version: wrong tag format: %s' "$bobshell_git_version"
			return 1
		fi
		printf %s "$bobshell_git_version"
		unset bobshell_git_version
	else
		bobshell_git_version_if_not_relase
	fi

}

bobshell_git_version_if_relase() {
	git describe
}

bobshell_git_version_if_not_relase() {
	git describe --abbrev=8 --always --dirty --broken
}

bobshell_git_is_clean() {
	bobshell_git_is_clean_output=$(git status --porcelain)
	test -z "$bobshell_git_is_clean_output"
}

bobshell_git_change_hash() {
	git diff HEAD | git hash-object --stdin
}