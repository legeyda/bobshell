

shelduck import string.sh

# use: bobshell_env_scope 'BOBSHELL_GIT_SSH_*=RUNWAY_GIT_SSH_*' -- command arg1 arg2
bobshell_env_scope() {
	bobshell_env_scope_command=
	
	while [ "${1:+defined}" = defined ]; do
		bobshell_split_once "$1" = bobshell_env_scope_key bobshell_env_scope_value


	done


	bobshell_env_scope_var_names=$(bobshell_list_var_names)
	for x in $(list); do
		if [ "$x" = -- ]; then
			break
		fi




		if [ -n "$bobshell_env_scope_command" ]; then
			bobshell_env_scope_command="$bobshell_env_scope_command "
		fi

		bobshell_env_scope_command="$bobshell_env_scope_command$"
	done

}


bobshell_list_var_names() {
	set | sed --silent --regexp-extended 's/^([A-Za-z_][A-Za-z_0-9]*)=.*$/\1/pg'
}