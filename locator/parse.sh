
shelduck import ../string.sh
shelduck import ../resource/copy.sh


bobshell_locator_parse() {
	bobshell_str_starts_with "$1" /
	if bobshell_result_check; then
		bobshell_locator_parse_type='file'
		bobshell_locator_parse_ref="$1"
	else
		bobshell_str_split_first "$1" : 
		if ! bobshell_result_check; then
			return
		fi
	fi


	if bobshell_starts_with "$1" /; then
		bobshell_locator_parse_type='file'
		bobshell_locator_parse_ref="$1"
	elif ! bobshell_split_first "$1" : bobshell_locator_parse_type bobshell_locator_parse_ref; then
		return 1
	fi

	case "$bobshell_locator_parse_type" in
		(val | var | eval | stdin | stdout | url)
			true
			;;
		(file)
			if bobshell_remove_prefix "$bobshell_locator_parse_ref" /// bobshell_locator_parse_ref; then
				bobshell_locator_parse_ref="/$bobshell_locator_parse_ref"
			elif bobshell_remove_prefix "$bobshell_locator_parse_ref" // bobshell_locator_parse_ref; then
				true
			elif bobshell_remove_prefix "$bobshell_locator_parse_ref" / bobshell_locator_parse_ref; then
				bobshell_locator_parse_ref="/$bobshell_locator_parse_ref"
			else
				true
			fi
			;;
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


bobshell_locator_parse_refactored() {
	bobshell_result_set false
	bobshell_event_fire bobshell_locator_parse_event
	# if ! bobshell_result_check _bobshell_locator_parse__type _bobshell_locator_parse__ref; then
	# 	return
	# fi


}

#bobshell_event_listen bobshell_locator_parse_event 'obshell_locator_parse_event_listener "$@"'
bobshell_locator_var_parse_event_listener() {
	if bobshell_remove_prefix "$1" var: _bobshell_locator_parse_event_listener__type; then
		bobshell_result_set true var "$_bobshell_locator_parse_event_listener__type"
		unset _bobshell_locator_parse_event_listener__type 
		return
	fi
}

bobshell_resource_copy_refactored() {
	bobshell_resource_copy false
	bobshell_event_fire bobshell_resource_copy_event "$@"
}

#bobshell_event_listen bobshell_resource_copy_event 'bobshell_resource_copy_var_to_remote_event_listener "$@"'
bobshell_resource_copy_var_to_remote_event_listener() {
	bobshell_result_set false
}