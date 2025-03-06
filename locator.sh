


shelduck import base.sh
shelduck import string.sh
shelduck import url.sh
shelduck import ./locator/is_file.sh
shelduck import ./locator/parse.sh

# deprecated see ./locator/parse.sh
bobshell_parse_locator() {
	bobshell_locator_parse "$1" "$2" "${3:-bobshell_parse_locator_type}" "${3:-bobshell_parse_locator_ref}"
}



# fun: bobshell_copy SOURCE DESTINATION
bobshell_copy() {
	bobshell_parse_locator "$1" bobshell_copy_source_type      bobshell_copy_source_ref
	bobshell_parse_locator "$2" bobshell_copy_destination_type bobshell_copy_destination_ref


	bobshell_copy_command="bobshell_copy_${bobshell_copy_source_type}_to_${bobshell_copy_destination_type}"
	if ! bobshell_command_available "$bobshell_copy_command"; then
		bobshell_die "bobshell_copy: unsupported copy $bobshell_copy_source_type to $bobshell_copy_destination_type"
	fi

	"$bobshell_copy_command" "$bobshell_copy_source_ref" "$bobshell_copy_destination_ref"
	
	unset bobshell_copy_source_type bobshell_copy_source_ref
	unset bobshell_copy_destination_type bobshell_copy_destination_ref
}


bobshell_copy_to_val()           { bobshell_die 'cannot write to val resource'; }
bobshell_copy_eval()             { bobshell_die 'eval resource cannot be destination'; }
bobshell_copy_to_stdin()         { bobshell_die 'cannot write to stdin resource'; }
bobshell_copy_stdout()           { bobshell_die 'cannot read from stdout resource'; }
bobshell_copy_to_url()           { bobshell_die 'cannot write to stdin resource'; }



bobshell_copy_val_to_val()       { test "$1" != "$2" && bobshell_copy_to_val; }
bobshell_copy_val_to_var()       { eval "$2='$1'"; }
bobshell_copy_val_to_eval()      { eval "$1"; }
bobshell_copy_val_to_stdin()     { bobshell_copy_to_stdin; }
bobshell_copy_val_to_stdout()    { printf %s "$1"; }
bobshell_copy_val_to_file()      { printf %s "$1" > "$2"; }
bobshell_copy_val_to_url()       { bobshell_copy_to_url; }



bobshell_copy_var_to_val()       { bobshell_copy_to_val; }
bobshell_copy_var_to_var()       { test "$1" != "$2" && eval "$2=\"\$$1\""; }
bobshell_copy_var_to_eval()      { eval "bobshell_copy_var_to_eval \"\$$1\""; }
bobshell_copy_var_to_stdin()     { bobshell_copy_to_stdin; }
bobshell_copy_var_to_stdout()    { eval "printf %s \"\$$1\""; }
bobshell_copy_var_to_file()      { eval "printf %s \"\$$1\"" > "$2"; }
bobshell_copy_var_to_url()       { bobshell_copy_to_url; }



bobshell_copy_eval_to_val()      { bobshell_copy_eval; }
bobshell_copy_eval_to_var()      { bobshell_copy_eval; }
bobshell_copy_eval_to_eval()     { bobshell_copy_eval; }
bobshell_copy_eval_to_stdin()    { bobshell_copy_eval; }
bobshell_copy_eval_to_stdout()   { bobshell_copy_eval; }
bobshell_copy_eval_to_file()     { bobshell_copy_eval; }
bobshell_copy_eval_to_url()      { bobshell_copy_eval; }



bobshell_copy_stdin_to_val()     { bobshell_copy_to_val; }
bobshell_copy_stdin_to_var()     { eval "$2=\$(cat)"; }
bobshell_copy_stdin_to_eval()    {
	bobshell_copy_stdin_to_var "$1" bobshell_copy_stdin_to_eval_data
	bobshell_copy_var_to_eval bobshell_copy_stdin_to_eval_data ''
	unset bobshell_copy_stdin_to_eval_data; 
}
bobshell_copy_stdin_to_stdin()   { bobshell_copy_to_stdin; }
bobshell_copy_stdin_to_stdout()  { cat; }
bobshell_copy_stdin_to_file()    { cat > "$2"; }
bobshell_copy_stdin_to_url()     { bobshell_copy_to_url; }



bobshell_copy_stdout_to_val()    { bobshell_copy_stdout; }
bobshell_copy_stdout_to_var()    { bobshell_copy_stdout; }
bobshell_copy_stdout_to_eval()   { bobshell_copy_stdout; }
bobshell_copy_stdout_to_stdin()  { bobshell_copy_stdout; }
bobshell_copy_stdout_to_stdout() { bobshell_copy_stdout; }
bobshell_copy_stdout_to_file()   { bobshell_copy_stdout; }
bobshell_copy_stdout_to_url()    { bobshell_copy_to_url; }



bobshell_copy_file_to_val()      { bobshell_copy_to_val; }
bobshell_copy_file_to_var()      { eval "$2=\$(cat '$1')"; }
bobshell_copy_file_to_eval()     {
	bobshell_copy_file_to_var "$1" bobshell_copy_file_to_eval_data
	bobshell_copy_var_to_eval bobshell_copy_file_to_eval_data ''
	unset bobshell_copy_file_to_eval_data; 
}
bobshell_copy_file_to_stdin()    { bobshell_copy_to_stdin; }
bobshell_copy_file_to_stdout()   { cat "$1"; }
bobshell_copy_file_to_file()     { test "$1" != "$2" && { mkdir -p "$(dirname "$2")" && rm -rf "$2" && cp -f "$1" "$2";}; }
bobshell_copy_file_to_url()      { bobshell_copy_to_url; }



bobshell_copy_url_to_val()       { bobshell_copy_to_val; }
bobshell_copy_url_to_var()       { bobshell_fetch_url "$1" | bobshell_copy_stdin_to_var '' "$2"; }
bobshell_copy_url_to_eval()      { bobshell_fetch_url "$1" | bobshell_copy_stdin_to_var '' "$2"; }
bobshell_copy_url_to_stdin()     { bobshell_copy_to_stdin; }
bobshell_copy_url_to_stdout()    { bobshell_fetch_url "$1"; }
bobshell_copy_url_to_file()      { bobshell_fetch_url "$1" | bobshell_copy_stdin_to_file '' "$2"; }
bobshell_copy_url_to_url()       { bobshell_copy_to_url; }



# fun: bobshell_locator_as_file LOCATOR
bobshell_locator_as_file() {
	if bobshell_starts_with "$1" "file:" bobshell_locator_as_file_ref; then
		copy_resource var:bobshell_locator_as_file_ref "$2"
	else
		# shellcheck disable=SC2034
		bobshell_locator_as_file_result="$(mktemp)"
		copy_resource "$1" "file:$bobshell_locator_as_file_result"
		copy_resource var:bobshell_locator_as_file_result "$2"
		unset bobshell_locator_as_file_result
	fi
	unset bobshell_locator_as_file_ref
}

bobshell_locator_is_stdin() {
	bobshell_remove_prefix "$1" stdin: "${2:-}"
}

bobshell_locator_is_stdout() {
	bobshell_remove_prefix "$1" stdout: "${2:-}"
}

# fun: bobshell_resource_is_appendable LOCATOR
bobshell_locator_is_appendable() {
	bobshell_starts_with "$1" var: stdout: file: /
}


bobshell_locator_is_remote() {
	bobshell_remove_prefix "$1" http:// "${2:-}" \
	  || bobshell_remove_prefix "$1" https:// "${2:-}" \
	  || bobshell_remove_prefix "$1" ftp:// "${2:-}"\
	  || bobshell_remove_prefix "$1" ftps:// "${2:-}"
}

bobshell_move() {
	bobshell_parse_locator "$1" bobshell_move_source_type      bobshell_move_source_ref
	bobshell_parse_locator "$2" bobshell_move_destination_type bobshell_move_destination_ref


	bobshell_move_command="bobshell_move_${bobshell_move_source_type}_to_${bobshell_move_destination_type}"
	if bobshell_command_available "$bobshell_move_command"; then
		"$bobshell_move_command" "$bobshell_move_source_ref" "$bobshell_move_destination_ref"
		unset bobshell_move_source_type bobshell_move_source_ref
		unset bobshell_move_destination_type bobshell_move_destination_ref
		return
	fi
	
	bobshell_copy "$1" "$2"
	bobshell_delete "$1"
}

bobshell_delete_file() { rm -f "$1"; }
bobshell_delete_var() { unset "$1"; }


bobshell_move_file_to_file() {
	bobshell_die not implemented
}

bobshell_delete() {
	bobshell_parse_locator "$1" bobshell_delete_type bobshell_delete_ref

	bobshell_delete_command="bobshell_delete_${bobshell_delete_type}"
	if ! bobshell_command_available "$bobshell_delete_command"; then
		bobshell_die "bobshell_delete: unsupported resource of type: $bobshell_delete_type"
	fi

	"$bobshell_delete_command" "$bobshell_delete_ref"
	return
}

bobshell_append() {
	bobshell_die not implemented
}




bobshell_append_to_val()           { bobshell_die 'cannot append to val resource'; }
bobshell_append_eval()             { bobshell_die 'eval resource cannot be destination'; }
bobshell_append_to_stdin()         { bobshell_die 'cannot append to stdin resource'; }
bobshell_append_stdout()           { bobshell_die 'cannot read from stdout resource'; }
bobshell_append_to_url()           { bobshell_die 'cannot append to stdin resource'; }



bobshell_append_val_to_val()       { test "$1" != "$2" && bobshell_append_to_val; }
bobshell_append_val_to_var()       { eval "$2='$1'"; }
bobshell_append_val_to_eval()      { eval "$1"; }
bobshell_append_val_to_stdin()     { bobshell_append_to_stdin; }
bobshell_append_val_to_stdout()    { printf %s "$1"; }
bobshell_append_val_to_file()      { printf %s "$1" > "$2"; }
bobshell_append_val_to_url()       { bobshell_append_to_url; }



bobshell_append_var_to_val()       { bobshell_append_to_val; }
bobshell_append_var_to_var()       { test "$1" != "$2" && eval "$2=\${$1}"; }
bobshell_append_var_to_eval()      { eval "bobshell_append_var_to_eval \"\$$1\""; }
bobshell_append_var_to_stdin()     { bobshell_append_to_stdin; }
bobshell_append_var_to_stdout()    { eval "printf %s \"\$$1\""; }
bobshell_append_var_to_file()      { eval "printf %s \"\$$1\"" > "$2"; }
bobshell_append_var_to_url()       { bobshell_append_to_url; }



bobshell_append_eval_to_val()      { bobshell_append_eval; }
bobshell_append_eval_to_var()      { bobshell_append_eval; }
bobshell_append_eval_to_eval()     { bobshell_append_eval; }
bobshell_append_eval_to_stdin()    { bobshell_append_eval; }
bobshell_append_eval_to_stdout()   { bobshell_append_eval; }
bobshell_append_eval_to_file()     { bobshell_append_eval; }
bobshell_append_eval_to_url()      { bobshell_append_eval; }



bobshell_append_stdin_to_val()     { bobshell_append_to_val; }
bobshell_append_stdin_to_var()     { eval "$2=\$(cat)"; }
bobshell_append_stdin_to_eval()    {
	bobshell_append_stdin_to_var "$1" bobshell_append_stdin_to_eval_data
	bobshell_append_var_to_eval bobshell_append_stdin_to_eval_data ''
	unset bobshell_append_stdin_to_eval_data; 
}
bobshell_append_stdin_to_stdin()   { bobshell_append_to_stdin; }
bobshell_append_stdin_to_stdout()  { cat; }
bobshell_append_stdin_to_file()    { cat > "$2"; }
bobshell_append_stdin_to_url()     { bobshell_append_to_url; }



bobshell_append_stdout_to_val()    { bobshell_append_stdout; }
bobshell_append_stdout_to_var()    { bobshell_append_stdout; }
bobshell_append_stdout_to_eval()   { bobshell_append_stdout; }
bobshell_append_stdout_to_stdin()  { bobshell_append_stdout; }
bobshell_append_stdout_to_stdout() { bobshell_append_stdout; }
bobshell_append_stdout_to_file()   { bobshell_append_stdout; }
bobshell_append_stdout_to_url()    { bobshell_append_to_url; }



bobshell_append_file_to_val()      { bobshell_append_to_val; }
bobshell_append_file_to_var()      { eval "$2=\$(cat '$1')"; }
bobshell_append_file_to_eval()     {
	bobshell_append_file_to_var "$1" bobshell_append_file_to_eval_data
	bobshell_append_var_to_eval bobshell_append_file_to_eval_data ''
	unset bobshell_append_file_to_eval_data; 
}
bobshell_append_file_to_stdin()    { bobshell_append_to_stdin; }
bobshell_append_file_to_stdout()   { cat "$1"; }
bobshell_append_file_to_file()     { test "$1" != "$2" && { mkdir -p "$(dirname "$2")" && rm -rf "$2" && cp "$1" "$2";}; }
bobshell_append_file_to_url()      { bobshell_append_to_url; }



bobshell_append_url_to_val()       { bobshell_append_to_val; }
bobshell_append_url_to_var()       { bobshell_fetch_url "$1" | bobshell_append_stdin_to_var '' "$2"; }
bobshell_append_url_to_eval()      { bobshell_fetch_url "$1" | bobshell_append_stdin_to_var '' "$2"; }
bobshell_append_url_to_stdin()     { bobshell_append_to_stdin; }
bobshell_append_url_to_stdout()    { bobshell_fetch_url "$1"; }
bobshell_append_url_to_file()      { bobshell_fetch_url "$1" | bobshell_append_stdin_to_file '' "$2"; }
bobshell_append_url_to_url()       { bobshell_append_to_url; }
