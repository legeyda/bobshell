

shelduck import string.sh
shelduck import resource/copy.sh
shelduck import locator/is_stdin.sh
shelduck import locator/is_stdout.sh
shelduck import ./redirect/io.sh
shelduck import ./redirect/input.sh
shelduck import ./misc/awk.sh

# fun: bobshell_ini_groups stdin:
bobshell_ini_list_groups() {
	bobshell_resource_copy "$1" stdout: | sed -n 's/^[[:space:]]*\[[[:space:]]*\([^\[ ]\+\)[[:space:]]*\][[:space:]]*$/\1/pg'
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

function get_group_def() {
	if($0 !~ /^[[:space:]]*\[[[:space:]]*(.*?)[[:space:]]*\][[:space:]]*$/) {
		return ""
	}
	_get_group__line=$0
	gsub(/^[[:space:]]*\[[[:space:]]*|[[:space:]]*\][[:space:]]*$/, "", _get_group__line)
	return _get_group__line
}

function get_key() {
	if($0 !~ /^[[:space:]]*(.*?)[[:space:]]*=.*$/) {
		#print("AAAA")
		#print($0 ": not key")
		return ""
	}
	_get_key__line=$0
	gsub(/^[[:space:]]*|[[:space:]]*=.*$/, "", _get_key__line)
	return _get_key__line
}

function is_target_key() {
	if(is_comment()) {
		return false;
	}
	return get_key() == target_key;
}


{
	if(!is_comment()) {
		maybe = get_group_def();
		if(maybe) {
			current_group = maybe;
			current_key = "";
		} else {
			current_key = get_key();
		}
	}
}
'

# fun: bobshell_init_keys DATA [GROUP]
bobshell_ini_list_keys() {
	bobshell_awk "$1" stdout: -v target_group="${2:-}" "$bobshell_ini_awk_common"'{
	if(is_target_group() && current_key) {
		print current_key
	}
}
'
}

# fun: bobshell_ini_get_value INPUT GROUP KEY
bobshell_ini_get_value() {
	bobshell_awk "$1" stdout: -v target_group="${2:-}" -v target_key="${3:-}" "$bobshell_ini_awk_common"'
{
	if(is_target_group() && is_target_key()) {
		current_value = $0
		gsub(/^.*?=[[:space:]]*|[[:space:]]*$/, "", current_value)
		if(current_value) {
			result = current_value
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

# fun: bobshell_ini_put_value INPUT OUTPUT GROUP KEY
bobshell_ini_delete_key() {
	bobshell_awk "$1" "$2" -v target_group="${3:-}" -v target_key="${4:-}" -v target_value="${5:-}" "$bobshell_ini_awk_common"'
{
	if(is_target_group() && is_target_key()) {
		// skip nothing
	} else {
		print
	}
}
'
}