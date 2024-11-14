
# fun: scope bobshell command [arg...]
# use: bobshell_shauth git clone blabl
shelduck notrace.sh
shelduck string.sh


bobshell_git_auth() {

  bobshell_ssh_init

  if [ -z "${GIT_SSH_COMMAND:-}" ]; then
    if [ -n "${BOBSHELL_SSH_KNOWN_HOSTS_FILE:-}" ]; then
      GIT_SSH_COMMAND="${GIT_SSH_COMMAND:-} -o $(bobshell_quote "UserKnownHostsFile=$BOBSHELL_SSH_KNOWN_HOSTS_FILE")"
    fi

    # shellcheck disable=SC2016
    if [ "${BOBSHELL_SSH_USE_AGENT:-true}" != 'true' ] && [ -n "${BOBSHELL_SSH_IDENTITY_FILE:-}" ]; then
      bobshell_git_auth_ssh_command="${GIT_SSH_COMMAND:-} -i '$(bobshell_quote "$BOBSHELL_SSH_IDENTITY_FILE")'"
    elif [ -n "${BOBSHELL_SSH_PASSWORD:-}" ] && bobshell_command_available sshpass; then
      set -- sshpass "-p$BOBSHELL_SSH_PASSWORD" "$@"
    fi
  fi

  export GIT_SSH_COMMAND
  "$@"
}


# shelduck_sshauth
bobshell_ssh_auth() {  
  bobshell_ssh_init

  # run
  if [ -n "${BOBSHELL_SSH_KNOWN_HOSTS_FILE:-}" ]; then
    bobshell_sshauth_executable="$1"
    shift
    set -- "$bobshell_sshauth_executable" -o "UserKnownHostsFile='$BOBSHELL_SSH_KNOWN_HOSTS_FILE'" "$@"
    unset bobshell_sshauth_executable
  fi

  # shellcheck disable=SC2016
  if [ "${BOBSHELL_SSH_USE_AGENT:-true}" != 'true' ] && [ -n "${BOBSHELL_SSH_IDENTITY_FILE:-}" ]; then
    bobshell_sshauth_executable="$1"
    shift
    set -- "$bobshell_sshauth_executable" -i "$BOBSHELL_SSH_IDENTITY_FILE" "$@"
    unset bobshell_sshauth_executable
  elif [ -n "${BOBSHELL_SSH_PASSWORD:-}" ] && bobshell_command_available sshpass; then
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
      chmod 600 "$BOBSHELL_SSH_IDENTITY_FILE" # ???
      # shellcheck disable=SC2016
      bobshell_notrace printf '%s\n' "$BOBSHELL_SSH_IDENTITY" > "$BOBSHELL_SSH_IDENTITY_FILE"
    fi
  fi

}




