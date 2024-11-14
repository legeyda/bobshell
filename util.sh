



# use: bobshell_env_scope 'BOBSHELL_GIT_SSH_*=RUNWAY_GIT_SSH*' -- command arg1 arg2
bobshell_env_scope() {
	bobshell_env_scope_command=
	for x in "$@"; do
		if [ "$x" = -- ]; then
			break
		fi




		if [ -n "$bobshell_env_scope_command" ]; then
			bobshell_env_scope_command="$bobshell_env_scope_command "
		fi

		bobshell_env_scope_command="$bobshell_env_scope_command$"
	done



}
