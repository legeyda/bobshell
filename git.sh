

bobshell_git() {
	bobshell_git_init
	GIT_SSH_COMMAND="${GIT_SSH_COMMAND:-$BOBSHELL_GIT_SSH_COMMAND}" command git "$@"
}


bobshell_git_init() {
	#bobshell_git_known_hosts_file=$(bobshell_getvar )


	if [ -z "${BOBSHELL_GIT_SSH_KNOWN_HOSTS_FILE:-}" ] && [ -n "${BOBSHELL_GIT_SSH_KNOWN_HOSTS}" ]; then
		BOBSHELL_GIT_SSH_KNOWN_HOSTS_FILE="$(mktemp)"
		printf %s "$BOBSHELL_GIT_SSH_KNOWN_HOSTS" > "$BOBSHELL_GIT_SSH_KNOWN_HOSTS_FILE"
	fi

	if [ -z "${BOBSHELL_GIT_SSH_KEY_FILE:-}" ] && [ -n "${BOBSHELL_GIT_SSH_KEY}" ]; then
		BOBSHELL_GIT_SSH_KEY_FILE="$(mktemp)"
		printf %s "$BOBSHELL_GIT_SSH_KEY" > "$BOBSHELL_GIT_SSH_KEY_FILE"
	fi

	# -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no
	export GIT_SSH_COMMAND="ssh '${BOBSHELL_GIT_SSH_KNOWN_HOSTS_FILE:+ -o "UserKnownHostsFile=$BOBSHELL_GIT_SSH_KNOWN_HOSTS_FILE"}' '${BOBSHELL_GIT_SSH_KEY_FILE:+ -i "$BOBSHELL_GIT_SSH_KEY_FILE"}' "
}
