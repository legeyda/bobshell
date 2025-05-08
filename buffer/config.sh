
shelduck import ../string.sh
shelduck import ../code/defun.sh
shelduck import ../redirect/output.sh

bobshell_buffer_config() {
	if ! bobshell_isset_1 "$@" || bobshell_starts_with "$1" stdout:; then
		_bobshell_buffer_config=$(bobshell_code_defun bobshell_buffer_printf 'printf "$@"')
		eval "$_bobshell_buffer_config"
		unset _bobshell_buffer_config
	elif bobshell_remove_prefix "$1" var: _bobshell_buffer_var; then
		# shellcheck disable=SC2016
		eval 'bobshell_buffer_printf() {
	_bobshell_buffer_printf=$(printf "$@"; printf z); _bobshell_buffer_printf=${_bobshell_buffer_printf%z}
	'"$_bobshell_buffer_var"'="${'"$_bobshell_buffer_var"':-}$_bobshell_buffer_printf" \
	unset _bobshell_buffer_printf
}'
	else
		bobshell_die "bobshell_buffer_config: for now only var: and stdout: supported"
	fi

}