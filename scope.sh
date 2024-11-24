

shelduck import base.sh
shelduck import locator.sh


bobshell_scope_names() {
	bobshell_scope_names_all=$(bobshell_vars)
	for bobshell_scope_names_scope in "$@"; do
		for bobshell_scope_names_item in $bobshell_scope_names_all; do
			if bobshell_starts_with "$bobshell_scope_names_item" "$bobshell_scope_names_scope"; then
				printf ' %s' "$bobshell_scope_names_item"
			fi
		done
	done
	unset bobshell_scope_names_all bobshell_scope_names_scope bobshell_scope_names_item
}



bobshell_scope_unset() {
	for bobshell_scope_unset_name in $(bobshell_scope_names "$@"); do
		unset "$bobshell_scope_unset_name"
	done
	unset bobshell_scope_unset_name
}



bobshell_scope_export() {
	for bobshell_scope_export_name in $(bobshell_scope_names "$@"); do
		export "$bobshell_scope_export_name"
	done
	unset bobshell_scope_export_name
}



bobshell_scope_env() {
	bobshell_scope_env_result=
	for bobshell_scope_env_name in $(bobshell_scope_names "$1"); do
		bobshell_scope_env_result="$bobshell_scope_env_result$bobshell_scope_env_name="
		bobshell_scope_env_value=$(bobshell_getvar "$bobshell_scope_env_name")
		bobshell_scope_env_value=$(bobshell_quote "$bobshell_scope_env_value")
		bobshell_scope_env_result="$bobshell_scope_env_result$bobshell_scope_env_value$bobshell_newline"
	done
	bobshell_copy var:bobshell_scope_env_result "$2"
	unset bobshell_scope_env_result bobshell_scope_env_name bobshell_scope_env_value
}



# fun: bobshell_scope_copy RUNDOODLE_GIT_SSH_ BOBSHELL_SSH_
bobshell_scope_copy() {
	bobshell_scope_unset "$2"
	for bobshell_scope_copy_name in $(bobshell_scope_names "$1"); do
		bobshell_scope_copy_value=$(bobshell_getvar "$bobshell_scope_copy_name")
		bobshell_remove_prefix "$bobshell_scope_copy_name" "$1" bobshell_scope_copy_name
		bobshell_putvar "$2$bobshell_scope_copy_name" "$bobshell_scope_copy_value"
	done
	unset bobshell_scope_copy_name bobshell_scope_copy_value
}




