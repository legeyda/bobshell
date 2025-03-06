
shelduck import ../string.sh
shelduck import ../resource/copy.sh


bobshell_locator_parse() {
	if bobshell_starts_with "$1" /; then
		bobshell_locator_parse_type='file'
		bobshell_locator_parse_ref="$1"
	elif ! bobshell_split_first "$1" : bobshell_locator_parse_type bobshell_locator_parse_ref; then
		return 1
	fi

	case "$bobshell_locator_parse_type" in
		(val | var | eval | stdin | stdout | file | url)
			true ;;
		(http | https | ftp | ftps) 
			bobshell_locator_parse_type=url
			bobshell_locator_parse_ref="$1"
			;;
		(*)
			return 1
	esac
	
	if [ -n "${2:-}" ]; then
		bobshell_resource_copy_val_to_var "$bobshell_locator_parse_type" "$2"
	fi
	if [ -n "${3:-}" ]; then
		bobshell_resource_copy_val_to_var "$bobshell_locator_parse_ref" "$3"
	fi
}
