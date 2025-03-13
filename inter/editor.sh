
shelduck import ../base.sh

# bobshell_inter_editor FILE
bobshell_inter_editor() {
	if bobshell_command_available editor; then
		editor "$@"
	elif bobshell_isset EDITOR; then
		"$EDITOR" "$@"
	else
		for _bobshell_inter_editor in nano vi emacs; do
			if bobshell_command_available "$_bobshell_inter_editor"; then
				"$_bobshell_inter_editor" "$@"
			fi
		done
		bobshell_die 'no editor configured'
	fi
}