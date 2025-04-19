


shelduck import ../locator/parse.sh
shelduck import ../base.sh
shelduck import ../result/set.sh
shelduck import ../result/check.sh
shelduck import ../string.sh
shelduck import ../var/get.sh

# fun: bobshell_resource_size LOCATOR
bobshell_resource_size() {
	bobshell_locator_parse "$1" _bobshell_resource_size__type _bobshell_resource_size__ref
	_bobshell_resource_size__command="bobshell_resource_size_$_bobshell_resource_size__type"
	if bobshell_command_available "$_bobshell_resource_size__command"; then
		"$_bobshell_resource_size__command" "$_bobshell_resource_size__ref"
	else
		bobshell_result_set false
	fi
	unset _bobshell_resource_size__type _bobshell_resource_size__ref _bobshell_resource_size__command
}

_bobshell_resource_size__tab=$(printf '\t')

bobshell_resource_size_file() {
	if _bobshell_resource_size_file=$(du -k "$1") && bobshell_split_first "$_bobshell_resource_size_file" "$_bobshell_resource_size__tab" bobshell_resource_size_file; then
		bobshell_result_set true _bobshell_resource_size_file
		unset _bobshell_resource_size_file
	else
		bobshell_result_set false
	fi
}

bobshell_resource_size_var() {
	if bobshell_isset "$1"; then
		bobshell_var_get "$1"
		if bobshell_result_check _bobshell_resource_size_var; then
			bobshell_result_set true "${#_bobshell_resource_size_var}"
			unset _bobshell_resource_size_var
			return
		fi
	fi
	bobshell_result_set false
}


bobshell_resource_size_val() {
	bobshell_result_set true "${#1}"
}