
bobshell_append_val_to_var() {
	eval "$2=\"\${$2:-}$1\""
}
