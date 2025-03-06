

shelduck import string.sh
shelduck import resource/copy.sh
shelduck import locator/is_stdin.sh
shelduck import locator/is_stdout.sh

# fun: bobshell_ini_groups stdin:
bobshell_ini_list_groups() {
	bobshell_resource_copy "$1" stdout: | sed -n 's/^[[:space:]]*\[[[:space:]]*\([^\[ ]\+\)[[:space:]]*\][[:space:]]*$/\1/pg'
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
		bobshell_resource_copy "$bobshell_redirect_input" var:bobshell_redirect_input
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
		bobshell_resource_copy "$bobshell_redirect_input" var:bobshell_redirect_input
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
		bobshell_resource_copy var:bobshell_redirect_output_data "$bobshell_redirect_output"
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

# shellcheck disable=SC2016
bobshell_ini_awk_common='
BEGIN {
	current_group = "";
	false = 0;
}

function get_group() {
	return current_group;
}

function is_target_group() {
	return get_group() == target_group;
}

function is_comment() {
	return ($0 ~ /^[[:space:]]*[#;].*$/);
}
function get_key() {
	if(is_comment()) {
		return false;
	}
	maybe=gensub(/^[[:space:]]*(.*[^[:space:]])[[:space:]]*=.*$/, "\\1", 1)
	return (maybe != $0) ? maybe : ""
}

function is_target_key() {
	if(is_comment()) {
		return false;
	}
	return get_key() == target_key;
}


{
	if(!is_comment()) {
		maybe=gensub(/^[[:space:]]*\[[[:space:]]*([^[:space:]]*?)[[:space:]]*\][[:space:]]*$/, "\\1", 1)
		if(maybe != $0) {
			current_group = maybe;
			current_key = "";
		} else {
			maybe = gensub(/^[[:space:]]*([^[:space:]]*?)[[:space:]]*=.*$/, "\\1", 1)
			current_key = (maybe != $0) ? maybe : "";
		}
	}
}
'

# fun: bobshell_init_keys DATA [GROUP]
bobshell_ini_list_keys() {
	bobshell_awk "$1" stdout: -v target_group="${2:-}" "$bobshell_ini_awk_common"'{
	if(is_target_group() && get_key()) {
		print maybe
	}
}
'
}

# fun: bobshell_ini_get_value INPUT GROUP KEY
bobshell_ini_get_value() {
	bobshell_awk "$1" stdout: -v target_group="${2:-}" -v target_key="${3:-}" "$bobshell_ini_awk_common"'
{
	if(is_target_group() && is_target_key()) {
		maybe=gensub(/^.*?=[[:space:]]*(.*[^[:space:]])[[:space:]]*$/, "\\1", 1)
		if (maybe != $0) {
			result = maybe
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

	bobshell_awk "$1" "$2" -v target_group="${3:-}" -v target_key="${4:-}" -v target_value="${5:-}" "$bobshell_ini_awk_common"'
{
	if(is_target_group()) {
		group_was_found=1
		if(is_target_key()) {
			printf("%s=%s\n", target_key, target_value)
			value_was_updated=1
		} else {
			print
		}
	} else if(group_was_found && !value_was_updated) {
		printf("%s=%s\n", target_key, target_value)
		print
	} else {
		print
	}
}
END {
	if(!value_was_updated) {
		if(is_target_group()) {
			printf("%s=%s\n", target_key, target_value)
		} else {
			printf("[%s]\n%s=%s\n", target_group, target_key, target_value)
		}
	}
}
'
}


