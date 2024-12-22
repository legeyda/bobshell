




bobshell_buffer_start() {
	bobshell_buffer_start_src=$(cat <<'EOF'
bobshell_buffer_printf() {
	bobshell_buffer_printf_value=$(printf "$@")
	bobshell_buffer="${bobshell_buffer:-}$bobshell_buffer_printf_value"
	unset bobshell_buffer_printf_value
}
EOF
)
	eval "$bobshell_buffer_start_src"
	unset bobshell_buffer_start_src
}

bobshell_buffer_stop() {
	bobshell_buffer_stop_src=$(cat <<'EOF'
bobshell_buffer_printf() {
	printf "$@"
}
EOF
)
	eval "$bobshell_buffer_stop_src"
	unset bobshell_buffer_stop_src
}

bobshell_buffer_stop

bobshell_buffer_clear() {
	unset bobshell_buffer
}

bobshell_buffer_get() {
	printf %s "${bobshell_buffer:-}"
}