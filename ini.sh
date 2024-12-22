

shelduck import string.sh
shelduck import locator.sh

# fun: bobshell_ini_groups stdin:
bobshell_ini_list_groups() {
	bobshell_copy "$1" stdout: | sed -n 's/^[[:space:]]*\[[[:space:]]*\([^\[ ]\+\)[[:space:]]*\][[:space:]]*$/\1/pg'
}



# fun: bobshell_redirect INPUT OUTPUT COMMAND [ARGS...]
bobshell_redirect() {
	bobshell_require_isset_3 "$@"

	bobshell_redirect_input="$1"
	shift

	bobshell_redirect_output="$1"
	shift

	if bobshell_locator_is_stdin "$bobshell_redirect_input"; then
		bobshell_redirect_output "$bobshell_redirect_output" "$@"
	elif bobshell_locator_is_stdout "$bobshell_redirect_output"; then
		bobshell_redirect_input "$bobshell_redirect_input" "$@"
	else
		bobshell_copy "$bobshell_redirect_input" var:bobshell_redirect_input
		bobshell_redirect_output "$bobshell_redirect_output" printf %s "$bobshell_redirect_input"
		unset bobshell_redirect_input
	fi
}

# fun: bobshell_redirect_input INPUT COMMAND [ARGS...]
bobshell_redirect_input() {
	bobshell_require_isset_2 "$@"

	bobshell_redirect_input="$1"
	shift

	if bobshell_locator_is_stdin "$bobshell_redirect_input"; then
		"$@"
	elif bobshell_locator_is_file "$bobshell_redirect_input" bobshell_redirect_input_file; then
		"$@" < "$bobshell_redirect_input_file"
		unset bobshell_redirect_input_file
	else
		bobshell_copy "$bobshell_redirect_input" var:bobshell_redirect_input
		printf %s "$bobshell_redirect_input" | "$@"
	fi
	unset bobshell_redirect_input
}

# fun: bobshell_redirect_output OUTPUT COMMAND [ARGS...]
bobshell_redirect_output() {
	bobshell_require_isset_2 "$@"
	bobshell_redirect_output="$1"
	shift
	if bobshell_locator_is_stdout "$bobshell_redirect_output"; then
		"$@"
	elif bobshell_locator_is_file "$bobshell_redirect_output" bobshell_redirect_output_file; then
		"$@" > "$bobshell_redirect_output_file"
		unset bobshell_redirect_output_file
	else
		bobshell_redirect_output_data=$("$@")
		bobshell_copy var:bobshell_redirect_output_data "$bobshell_redirect_output"
		unset bobshell_redirect_output_data
	fi
	unset bobshell_redirect_output
}


# fun: bobshell_awk INPUT OUTPUT AWKARGS...
bobshell_awk() {
	bobshell_require_isset_3 "$@"
	
	bobshell_awk__input="$1"
	shift

	bobshell_awk__output="$1"
	shift
	
	if bobshell_locator_is_file "$bobshell_awk__input" bobshell_awk__input_file; then
		bobshell_redirect_output "$bobshell_awk__output" awk "$@" "$bobshell_awk__input_file"
		unset bobshell_awk__input_file
	else
		bobshell_redirect "$bobshell_awk__input" "$bobshell_awk__output" awk "$@"
		unset bobshell_awk__input bobshell_awk__output
	fi
}

bobshell_ini_awk_header='BEGIN { is_target_group=("" == target_group) ? 1 : 0; }
{
	maybe=gensub(/^[[:space:]]*\[[[:space:]]*([^[:space:]]*?)[[:space:]]*\][[:space:]]*$/, "\\1", 1)
	if(maybe != $0) {
		is_target_group=(maybe == target_group) ? 1 : 0;
	}
}
'

# fun: bobshell_init_keys DATA [GROUP]
bobshell_ini_list_keys() {
	bobshell_awk "$1" stdout: -v target_group="${2:-}" "$bobshell_ini_awk_header"'{
	if(is_target_group) {
		maybe=gensub(/^[[:space:]]*([^[:space:]]*?)[[:space:]]*=.*$/, "\\1", 1)
		if (maybe != $0) {
			print maybe
		}
	}
}
'
}

# fun: bobshell_ini_get_value INPUT GROUP KEY
bobshell_ini_get_value() {
	bobshell_awk "$1" stdout: -v target_group="${2:-}" -v target_key="${3:-}" "$bobshell_ini_awk_header"'{
	if(is_target_group) {
		maybe=gensub(/^[[:space:]]*([^[:space:]]*?)[[:space:]]*=.*$/, "\\1", 1)
		if (maybe != $0 && maybe == target_key) {
			maybe=gensub(/^.*?=[[:space:]]*(.*[^[:space:]])[[:space:]]*$/, "\\1", 1)
			if (maybe != $0) {
				result = maybe
			}
		}
	}
}
END {
	print result
}
'
}

# fun: bobshell_ini_put_value INPUT OUTPUT GROUP KEY VALUE
bobshell_ini_put_value() {
	bobshell_awk "$1" "$2" -v target_group="${3:-}" -v target_key="${4:-}" -v target_value="${5:-}" "$bobshell_ini_awk_header"'{
	if(is_target_group) {
		maybe=gensub(/^[[:space:]]*([^[:space:]]*?)[[:space:]]*=.*$/, "\\1", 1)
		if (maybe != $0 && maybe == target_key) {
			printf("%s=%s\n", target_key, target_value)
			next
		}
	}
	print
}
'
}


