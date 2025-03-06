
# fun: scope bobshell command [arg...]
# use: bobshell_shauth git clone blabl
shelduck import notrace.sh
shelduck import string.sh
shelduck import util.sh
shelduck import locator.sh


# use: bobshell_ssh user@host echo hello
bobshell_ssh() {
	sleep "${BOBSHELL_SSH_DELAY:-0}"
	bobshell_ssh_auth ssh "$@"
}



bobshell_scp() {
	sleep "${BOBSHELL_SSH_DELAY:-0}"
	bobshell_ssh_auth scp "$@"
}



bobshell_ssh_auth() {
		
	if [ -n "${BOBSHELL_SSH_PORT:-}" ]; then
		bobshell_sshauth_executable="$1"
		shift
		set -- "$bobshell_sshauth_executable" -p "$BOBSHELL_SSH_PORT" "$@"
		unset bobshell_sshauth_executable
	fi

	# ssh-keyscan -H host "$(dig +short host)""
	if [ -z "${BOBSHELL_SSH_KNOWN_HOSTS_FILE:-}" ] && [ -n "${BOBSHELL_SSH_KNOWN_HOSTS:-}" ]; then
		BOBSHELL_SSH_KNOWN_HOSTS_FILE="$(mktemp)"
		printf '%s\n' "$BOBSHELL_SSH_KNOWN_HOSTS" > "$BOBSHELL_SSH_KNOWN_HOSTS_FILE"
	fi
	if [ -n "${BOBSHELL_SSH_KNOWN_HOSTS_FILE:-}" ]; then
		bobshell_sshauth_executable="$1"
		shift
		set -- "$bobshell_sshauth_executable" -o "UserKnownHostsFile='$BOBSHELL_SSH_KNOWN_HOSTS_FILE'" "$@"
		unset bobshell_sshauth_executable
	fi
	if [ -n "${BOBSHELL_SSH_USER:-}" ]; then
		bobshell_sshauth_executable="$1"
		shift
		set -- "$bobshell_sshauth_executable" -o "User='$BOBSHELL_SSH_USER'" "$@"
		unset bobshell_sshauth_executable
	fi
	if bobshell_isset BOBSHELL_SSH_CONNECT_TIMEOUT; then
		_bobshell_ssh_auth__executable="$1"
		shift
		set -- "$_bobshell_ssh_auth__executable" -o "ConnectTimeout=$BOBSHELL_SSH_CONNECT_TIMEOUT" "$@"
		unset _bobshell_ssh_auth__executable
	fi
	if bobshell_isset BOBSHELL_SSH_CONNECTION_ATTEMPTS; then
		_bobshell_ssh_auth__executable="$1"
		shift
		set -- "$_bobshell_ssh_auth__executable" -o "ConnectionAttempts=$BOBSHELL_SSH_CONNECTION_ATTEMPTS" "$@"
		unset _bobshell_ssh_auth__executable
	fi

	if [ -n "${BOBSHELL_SSH_IDENTITY:-}" ]; then
		if [ "${BOBSHELL_SSH_USE_AGENT:-true}" == 'true' ]; then
			if [ -z "${SSH_AGENT_PID:-}" ]; then
				bobshell_eval_output ssh-agent >&2
				# todo copy_resource 'stdout:ssh-agent' eval:
			fi
			bobshell_notrace printf '%s\n' "$BOBSHELL_SSH_IDENTITY" | ssh-add -q -t 5 -
		elif [ -z "${BOBSHELL_SSH_IDENTITY_FILE:-}" ]; then
			BOBSHELL_SSH_IDENTITY_FILE="$(mktemp)"
			chmod 600 "$BOBSHELL_SSH_IDENTITY_FILE" # ???
			# shellcheck disable=SC2016
			bobshell_notrace printf '%s\n' "$BOBSHELL_SSH_IDENTITY" > "$BOBSHELL_SSH_IDENTITY_FILE"
		fi
	fi
	
	if [ -n "${BOBSHELL_SSH_IDENTITY_FILE:-}" ]; then
		bobshell_sshauth_executable="$1"
		shift
		set -- "$bobshell_sshauth_executable" -i "$BOBSHELL_SSH_IDENTITY_FILE" "$@"
		unset bobshell_sshauth_executable
	fi

	bobshell_maybe_sshpass "$@"
}



bobshell_maybe_sshpass() {
	if [ -n "${BOBSHELL_SSH_PASSWORD:-}" ] && bobshell_command_available sshpass; then
		set -- sshpass "-p$BOBSHELL_SSH_PASSWORD" "$@"
	fi
	"$@"
}


bobshell_ssh_keyscan() {
	for bobshell_ssh_keyscan_host in "$@"; do
		bobshell_ssh_keyscan_addr=$(dig +short "$bobshell_ssh_keyscan_host")
		set -- "$@" "$bobshell_ssh_keyscan_addr"
	done
	unset bobshell_ssh_keyscan_host bobshell_ssh_keyscan_addr
	bobshell_ssh_auth ssh-keyscan "$@"
}



# fun: bobshell_ssh_keygen FILE
bobshell_ssh_keygen() {
	bobshell_ssh_keygen_dir=$(dirname "$1")
	mkdir -p "$bobshell_ssh_keygen_dir"
	rm -f "$1" "$1.pub"
	ssh-keygen -q -t ed25519 -b 2048 -N '' -f "$1"
}



# fun: bobshell_get_private_key FILEPATH LOCATOR
bobshell_copy_private_key() {
	bobshell_copy "file:$1" "$2"
}



# fun: bobshell_get_public_key FILEPATH LOCATOR
bobshell_copy_public_key() {
	bobshell_copy "file:$1.pub" "$2"
}



