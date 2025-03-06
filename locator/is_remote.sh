

shelduck import ../string.sh

bobshell_locator_is_remote() {
	bobshell_remove_prefix "$1" http:// "${2:-}" \
	  || bobshell_remove_prefix "$1" https:// "${2:-}" \
	  || bobshell_remove_prefix "$1" ftp:// "${2:-}"\
	  || bobshell_remove_prefix "$1" ftps:// "${2:-}"
}