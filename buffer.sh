


bobshell_buffer_printf() {
	bobshell_buffer_printf_value=$(printf "$@")
	bobshell_buffer="${bobshell_buffer:-}$bobshell_buffer_printf_value"
	unset bobshell_buffer_printf_value
}

bobshell_buffer_clear() {
	unset bobshell_buffer
}

bobshell_buffer_get() {
	printf %s "${bobshell_buffer:-}"
}