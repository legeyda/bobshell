
# scope bobshell
shelduck notrace.sh


# shelduck_sshauth
bobshell_sshauth() {
  # config
  if { [ -z "${__ENV__SSH_KNOWN_HOSTS_FILE:-}" ] || [ ! -f "$__ENV__SSH_KNOWN_HOSTS_FILE" ] ;} \
      && [ -n "${__ENV__SSH_KNOWN_HOSTS:-}" ]; then
    __ENV__SSH_KNOWN_HOSTS_FILE="$(mktemp)"
    printf '%s\n' "$__ENV__SSH_KNOWN_HOSTS" > "$__ENV__SSH_KNOWN_HOSTS_FILE"
  fi

  if [ "${__ENV__SSH_USE_AGENT:-true}" = 'false' ] \
      && { [ -z "${__ENV__SSH_IDENTITY_FILE:-}" ] || [ ! -f "$__ENV__SSH_IDENTITY_FILE" ] ;} \
      && [ -n "${__ENV__SSH_IDENTITY:-}" ]; then
    __ENV__SSH_IDENTITY_FILE="$(mktemp)"
    # shellcheck disable=SC2016
    bobshell_notrace 'printf "%s\\n" "$__ENV__SSH_IDENTITY"' > "$__ENV__SSH_IDENTITY_FILE"
  fi

  : "${__ENV__SSH_PASSWORD:=${__ENV__REMOTE_USER_PASSWORD:-}}"

  # run
  if [ -n "${__ENV__SSH_KNOWN_HOSTS_FILE:-}" ]; then
    __scope__executable="$1"
    shift
    set -- "$__scope__executable" -o "UserKnownHostsFile='$__ENV__SSH_KNOWN_HOSTS_FILE'" "$@"
    unset __scope__executable
  fi

  # shellcheck disable=SC2016
  if [ -n "${__ENV__SSH_IDENTITY_FILE:-}" ]; then
    chmod 600 "$__ENV__SSH_IDENTITY_FILE" # ???
    __scope__executable="$1"
    shift
    set -- "$__scope__executable" -i "$__ENV__SSH_IDENTITY_FILE" "$@"
    unset __scope__executable
  elif bobshell_notrace 'test -n "${__ENV__SSH_IDENTITY:-}"'; then
    if [ -z "${SSH_AGENT_PID:-}" ]; then
      eval "$(ssh-agent)"
    fi
    bobshell_notrace 'printf "%s\\n" "$__ENV__SSH_IDENTITY"' | ssh-add -q -t 5 -
  elif [ -n "${__ENV__SSH_PASSWORD:-}" ]; then
    set -- sshpass "-p$__ENV__SSH_PASSWORD" "$@"
  fi

  "$@"
}
