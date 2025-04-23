

shelduck import ../locator/parse.sh
shelduck import ../resource/copy.sh
shelduck import ../base.sh
shelduck import ../string.sh
shelduck import ../str/quote.sh
shelduck import ../url.sh



# fun: bobshell_resource_copy SOURCE DESTINATION
bobshell_resource_copy() {
	bobshell_locator_parse "$1" bobshell_resource_copy_source_type      bobshell_resource_copy_source_ref
	bobshell_locator_parse "$2" bobshell_resource_copy_destination_type bobshell_resource_copy_destination_ref


	bobshell_resource_copy_command="bobshell_resource_copy_${bobshell_resource_copy_source_type}_to_${bobshell_resource_copy_destination_type}"
	if ! bobshell_command_available "$bobshell_resource_copy_command"; then
		bobshell_die "bobshell_resource_copy: unsupported copy $bobshell_resource_copy_source_type to $bobshell_resource_copy_destination_type"
	fi

	"$bobshell_resource_copy_command" "$bobshell_resource_copy_source_ref" "$bobshell_resource_copy_destination_ref"
	
	unset bobshell_resource_copy_source_type bobshell_resource_copy_source_ref
	unset bobshell_resource_copy_destination_type bobshell_resource_copy_destination_ref
}


bobshell_resource_copy_to_val()           { bobshell_die 'cannot write to val resource'; }
bobshell_resource_copy_eval()             { bobshell_die 'eval resource cannot be destination'; }
bobshell_resource_copy_to_stdin()         { bobshell_die 'cannot write to stdin resource'; }
bobshell_resource_copy_stdout()           { bobshell_die 'cannot read from stdout resource'; }
bobshell_resource_copy_to_url()           { bobshell_die 'cannot write to stdin resource'; }



bobshell_resource_copy_val_to_val()       { test "$1" != "$2" && bobshell_resource_copy_to_val; }
bobshell_resource_copy_val_to_var()       {
	bobshell_str_quote "$1"	
	eval "$2=$bobshell_result_1"
}
bobshell_resource_copy_val_to_eval()      { eval "$1"; }
bobshell_resource_copy_val_to_stdin()     { bobshell_resource_copy_to_stdin; }
bobshell_resource_copy_val_to_stdout()    { printf %s "$1"; }
bobshell_resource_copy_val_to_file()      { printf %s "$1" > "$2"; }
bobshell_resource_copy_val_to_url()       { bobshell_resource_copy_to_url; }



bobshell_resource_copy_var_to_val()       { bobshell_resource_copy_to_val; }
bobshell_resource_copy_var_to_var()       { test "$1" != "$2" && eval "$2=\"\$$1\""; }
bobshell_resource_copy_var_to_eval()      { eval "bobshell_resource_copy_var_to_eval \"\$$1\""; }
bobshell_resource_copy_var_to_stdin()     { bobshell_resource_copy_to_stdin; }
bobshell_resource_copy_var_to_stdout()    { eval "printf %s \"\$$1\""; }
bobshell_resource_copy_var_to_file()      { eval "printf %s \"\$$1\"" > "$2"; }
bobshell_resource_copy_var_to_url()       { bobshell_resource_copy_to_url; }



bobshell_resource_copy_eval_to_val()      { bobshell_resource_copy_eval; }
bobshell_resource_copy_eval_to_var()      { bobshell_resource_copy_eval; }
bobshell_resource_copy_eval_to_eval()     { bobshell_resource_copy_eval; }
bobshell_resource_copy_eval_to_stdin()    { bobshell_resource_copy_eval; }
bobshell_resource_copy_eval_to_stdout()   { bobshell_resource_copy_eval; }
bobshell_resource_copy_eval_to_file()     { bobshell_resource_copy_eval; }
bobshell_resource_copy_eval_to_url()      { bobshell_resource_copy_eval; }



bobshell_resource_copy_stdin_to_val()     { bobshell_resource_copy_to_val; }
bobshell_resource_copy_stdin_to_var()     { eval "$2=\$(cat)"; }
bobshell_resource_copy_stdin_to_eval()    {
	bobshell_resource_copy_stdin_to_var "$1" bobshell_resource_copy_stdin_to_eval_data
	bobshell_resource_copy_var_to_eval bobshell_resource_copy_stdin_to_eval_data ''
	unset bobshell_resource_copy_stdin_to_eval_data; 
}
bobshell_resource_copy_stdin_to_stdin()   { bobshell_resource_copy_to_stdin; }
bobshell_resource_copy_stdin_to_stdout()  { cat; }
bobshell_resource_copy_stdin_to_file()    { cat > "$2"; }
bobshell_resource_copy_stdin_to_url()     { bobshell_resource_copy_to_url; }



bobshell_resource_copy_stdout_to_val()    { bobshell_resource_copy_stdout; }
bobshell_resource_copy_stdout_to_var()    { bobshell_resource_copy_stdout; }
bobshell_resource_copy_stdout_to_eval()   { bobshell_resource_copy_stdout; }
bobshell_resource_copy_stdout_to_stdin()  { bobshell_resource_copy_stdout; }
bobshell_resource_copy_stdout_to_stdout() { bobshell_resource_copy_stdout; }
bobshell_resource_copy_stdout_to_file()   { bobshell_resource_copy_stdout; }
bobshell_resource_copy_stdout_to_url()    { bobshell_resource_copy_to_url; }


bobshell_resource_copy_file_to_val()      { bobshell_resource_copy_to_val; }
bobshell_resource_copy_file_to_var()      { eval "$2=\$(cat '$1'; printf z); $2=\${$2%z}"; }
bobshell_resource_copy_file_to_eval()     {
	bobshell_resource_copy_file_to_var "$1" bobshell_resource_copy_file_to_eval_data
	bobshell_resource_copy_var_to_eval bobshell_resource_copy_file_to_eval_data ''
	unset bobshell_resource_copy_file_to_eval_data; 
}
bobshell_resource_copy_file_to_stdin()    { bobshell_resource_copy_to_stdin; }
bobshell_resource_copy_file_to_stdout()   { cat "$1"; }
bobshell_resource_copy_file_to_file()     { test "$1" != "$2" && { mkdir -p "$(dirname "$2")" && rm -rf "$2" && cp -f "$1" "$2";}; }
bobshell_resource_copy_file_to_url()      { bobshell_resource_copy_to_url; }



bobshell_resource_copy_url_to_val()       { bobshell_resource_copy_to_val; }
bobshell_resource_copy_url_to_var()       { eval "$2"'=$(bobshell_fetch_url '"'""$1""'"')'; }
bobshell_resource_copy_url_to_eval()      {
	bobshell_resource_copy_url_to_var "$1" _bobshell_resource_copy_url_to_eval
	eval "$_bobshell_resource_copy_url_to_eval"
	unset _bobshell_resource_copy_url_to_eval 
}
bobshell_resource_copy_url_to_stdin()     { bobshell_resource_copy_to_stdin; }
bobshell_resource_copy_url_to_stdout()    { bobshell_fetch_url "$1"; }
bobshell_resource_copy_url_to_file()      { bobshell_fetch_url "$1" > "$2"; }
bobshell_resource_copy_url_to_url()       { bobshell_resource_copy_to_url; }
