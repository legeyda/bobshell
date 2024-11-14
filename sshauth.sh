
# fun: scope bobshell command [arg...]
# use: bobshell_shauth git clone blabl
shelduck notrace.sh
shelduck string.sh


bobshell_git_ssh_options() {
  GIT_SSH_COMMAND=$(bobshell_sshauth bobshell_quote)
}


# shelduck_sshauth
bobshell_sshauth() {
  bobshell_ssh_init

  # run
  if [ -n "${BOBSHELL_SSH_KNOWN_HOSTS_FILE:-}" ]; then
    bobshell_sshauth_executable="$1"
    shift
    set -- "$bobshell_sshauth_executable" -o "UserKnownHostsFile='$BOBSHELL_SSH_KNOWN_HOSTS_FILE'" "$@"
    unset bobshell_sshauth_executable
  fi
  
  # shellcheck disable=SC2016
  if [ -n "${BOBSHELL_SSH_IDENTITY_FILE:-}" ]; then
    chmod 600 "$BOBSHELL_SSH_IDENTITY_FILE" # ???
    bobshell_sshauth_executable="$1"
    shift
    set -- "$bobshell_sshauth_executable" -i "$BOBSHELL_SSH_IDENTITY_FILE" "$@"
    unset bobshell_sshauth_executable
  elif bobshell_notrace test -n "${BOBSHELL_SSH_IDENTITY:-}"; then
    if [ -z "${SSH_AGENT_PID:-}" ]; then
      eval "$(ssh-agent)"
    fi
    bobshell_notrace printf '%s\n' "$BOBSHELL_SSH_IDENTITY" | ssh-add -q -t 5 -
  elif [ -n "${BOBSHELL_SSH_PASSWORD:-}" ]; then
    set -- sshpass "-p$BOBSHELL_SSH_PASSWORD" "$@"
  fi

  "$@"
}

bobshell_ssh_init() {
  
  # config
  if [ -z "${BOBSHELL_SSH_KNOWN_HOSTS_FILE:-}" ] && [ -n "${BOBSHELL_SSH_KNOWN_HOSTS:-}" ]; then
    BOBSHELL_SSH_KNOWN_HOSTS_FILE="$(mktemp)"
    printf '%s\n' "$BOBSHELL_SSH_KNOWN_HOSTS" > "$BOBSHELL_SSH_KNOWN_HOSTS_FILE"
  fi


  if [ -n "${BOBSHELL_SSH_IDENTITY:-}" ]; then
    if [ "${BOBSHELL_SSH_USE_AGENT:-true}" = 'true' ]; then
      if [ -z "${SSH_AGENT_PID:-}" ]; then
        eval "$(ssh-agent)"
      fi
      bobshell_notrace printf '%s\n' "$BOBSHELL_SSH_IDENTITY" | ssh-add -q -t 5 -
    elif [ -z "${BOBSHELL_SSH_IDENTITY_FILE:-}" ]; then
      BOBSHELL_SSH_IDENTITY_FILE="$(mktemp)"
      # shellcheck disable=SC2016
      bobshell_notrace printf '%s\n' "$BOBSHELL_SSH_IDENTITY" > "$BOBSHELL_SSH_IDENTITY_FILE"
    fi
  fi

}









# shelduck_sshauth
bobshell_sshauth_old() {
  # config
  if { [ -z "${BOBSHELL_SSH_KNOWN_HOSTS_FILE:-}" ] || [ ! -f "$BOBSHELL_SSH_KNOWN_HOSTS_FILE" ] ;} \
      && [ -n "${BOBSHELL_SSH_KNOWN_HOSTS:-}" ]; then
    BOBSHELL_SSH_KNOWN_HOSTS_FILE="$(mktemp)"
    printf '%s\n' "$BOBSHELL_SSH_KNOWN_HOSTS" > "$BOBSHELL_SSH_KNOWN_HOSTS_FILE"
  fi

  if [ "${BOBSHELL_SSH_USE_AGENT:-true}" = 'false' ] \
      && { [ -z "${BOBSHELL_SSH_IDENTITY_FILE:-}" ] || [ ! -f "$BOBSHELL_SSH_IDENTITY_FILE" ] ;} \
      && [ -n "${BOBSHELL_SSH_IDENTITY:-}" ]; then
    BOBSHELL_SSH_IDENTITY_FILE="$(mktemp)"
    # shellcheck disable=SC2016
    bobshell_notrace 'printf "%s\\n" "$BOBSHELL_SSH_IDENTITY"' > "$BOBSHELL_SSH_IDENTITY_FILE"
  fi

  : "${BOBSHELL_SSH_PASSWORD:=${BOBSHELL_REMOTE_USER_PASSWORD:-}}"

  # run
  if [ -n "${BOBSHELL_SSH_KNOWN_HOSTS_FILE:-}" ]; then
    bobshell_sshauth_executable="$1"
    shift
    set -- "$bobshell_sshauth_executable" -o "UserKnownHostsFile='$BOBSHELL_SSH_KNOWN_HOSTS_FILE'" "$@"
    unset bobshell_sshauth_executable
  fi

  # shellcheck disable=SC2016
  if [ -n "${BOBSHELL_SSH_IDENTITY_FILE:-}" ]; then
    chmod 600 "$BOBSHELL_SSH_IDENTITY_FILE" # ???
    bobshell_sshauth_executable="$1"
    shift
    set -- "$bobshell_sshauth_executable" -i "$BOBSHELL_SSH_IDENTITY_FILE" "$@"
    unset bobshell_sshauth_executable
  elif bobshell_notrace 'test -n "${BOBSHELL_SSH_IDENTITY:-}"'; then
    if [ -z "${SSH_AGENT_PID:-}" ]; then
      eval "$(ssh-agent)"
    fi
    bobshell_notrace 'printf "%s\\n" "$BOBSHELL_SSH_IDENTITY"' | ssh-add -q -t 5 -
  elif [ -n "${BOBSHELL_SSH_PASSWORD:-}" ]; then
    set -- sshpass "-p$BOBSHELL_SSH_PASSWORD" "$@"
  fi

  "$@"
}
