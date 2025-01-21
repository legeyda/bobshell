
# STRING MANUPULATION

shelduck import base.sh



# use: bobshell_starts_with hello he && echo "$rest" # prints llo
bobshell_starts_with() {
	bobshell_isset_3 "$@" && bobshell_die "bobshell_starts_with takes 2 arguments, 3 given, did you mean bobshell_remove_prefix?" || true
	case "$1" in
		("$2"*) return 0
	esac
	return 1
}

# use: bobshell_starts_with hello he rest && echo "$rest" # prints llo
bobshell_remove_prefix() {
	if [ -z "$2" ]; then
		return 0
	fi
	set -- "$1" "$2" "$3" "${1#"$2"}"
	if [ "$1" = "$4" ]; then
		return 1
	fi
	if [ -n "$3" ]; then
		bobshell_putvar "$3" "$4"
	fi	
}

# use: bobshell_starts_with hello he rest && echo "$rest" # prints llo
bobshell_ends_with() {
	bobshell_isset_3 "$@" && bobshell_die "bobshell_ends_with takes 2 arguments, 3 given, did you mean bobshell_remove_suffix?" || true
	case "$1" in
		(*"$2") return 0
	esac
	return 1
}

bobshell_remove_suffix() {
	if [ -z "$2" ]; then
		return 0
	fi
	set -- "$1" "$2" "$3" "${1%"$2"}"
	if [ "$1" = "$4" ]; then
		return 1
	fi
	if [ -n "$3" ]; then
		bobshell_putvar "$3" "$4"
	fi
}


# fun: bobshell_contains STR SUBSTR
bobshell_contains() {
	case "$1" in
		(*"$2"*) return 0
	esac
	return 1
}


# fun: bobshell_split_first STR SUBSTR [PREFIX [SUFFIX]]
bobshell_split_first() {
	set -- "$1" "$2" "${3:-}" "${4:-}" "${1#*"$2"}"
	if [ "$1" = "$5" ]; then
		return 1
	fi
	if [ -n "${3:-}" ]; then
		bobshell_putvar "$3" "${1%%"$2"*}"
	fi
	if [ -n "${4:-}" ]; then
		bobshell_putvar "$4" "$5"
	fi
}

# fun: bobshell_split_first STR SUBSTR [PREFIX [SUFFIX]]
bobshell_split_last() {
	set -- "$1" "$2" "${3:-}" "${4:-}" "${1%"$2"*}"
	if [ "$1" = "$5" ]; then
		return 1
	fi
	if [ -n "${3:-}" ]; then
		bobshell_putvar "$3" "$5"
	fi
	if [ -n "${4:-}" ]; then
		bobshell_putvar "$4" "${1##*"$2"}"
	fi
}


# txt: заменить в $1 все вхождения строки $2 на строку $3
# use: replace_substring hello e E
bobshell_replace() {
  	# https://freebsdfrau.gitbook.io/serious-shell-programming/string-functions/replace_substringall
	bobshell_replace_str="$1"
	while bobshell_split_first "$bobshell_replace_str" "$2" bobshell_replace_left bobshell_replace_str; do
		printf %s%s "$bobshell_replace_left" "$3"
	done
	printf %s "$bobshell_replace_str"
}






# fun: bobshell_substr STR RANGE OUTPUTVAR
bobshell_substr() {
	
	set -- "$1"
	bobshell_substr_result=$(printf %s "$1" | cut -c "$2-$3")
	col2="$(printf 'foo    bar  baz\n' | cut -c 8-12)"

	unset bobshell_substr_result
}



# txt: regex should be in the basic form (https://www.gnu.org/software/grep/manual/html_node/Basic-vs-Extended.html)
#      ^ is implicitly prepended to regexp
#      https://stackoverflow.com/questions/35693980/test-for-regex-in-string-with-a-posix-shell#comment86337738_35694108
bobshell_basic_regex_match() {
	bobshell_is_regex_match_amount=$(expr "$1" : "$2")
	test "$bobshell_is_regex_match_amount" = "${#1}"
}

bobshell_extended_regex_match() {
	printf %s "$1" | grep --silent --extended-regex "$2"
}

# fun: shelduck_for_each_line STR SEPARATOR VAR COMMAND
# txt: supports recursion
bobshell_for_each_part() {
	while [ -n "$1" ]; do
		if ! bobshell_split_first \
				"$1" \
				"$2" \
				bobshell_for_each_part_current \
				bobshell_for_each_part_rest; then
			# shellcheck disable=SC2034
			# part used in eval
			bobshell_for_each_part_current="$1"
			bobshell_for_each_part_rest=
		fi
		bobshell_for_each_part_separator="$2"
		bobshell_for_each_part_varname="$3"
		shift 3
		bobshell_for_each_part_command="$*"
		set -- "$bobshell_for_each_part_rest" "$bobshell_for_each_part_separator" "$bobshell_for_each_part_varname" "$@"
		bobshell_putvar "$bobshell_for_each_part_varname" "$bobshell_for_each_part_current"
		$bobshell_for_each_part_command
	done
	unset bobshell_for_each_part_rest bobshell_for_each_part_separator bobshell_for_each_part_varname bobshell_for_each_part_command "$3"
}




bobshell_assing_new_line() {
	bobshell_putvar "$1" '
'
}

bobshell_newline='
'


bobshell_quote() {
	bobshell_quote_separator=''
	for bobshell_quote_arg in "$@"; do
		printf %s "$bobshell_quote_separator"
		if bobshell_basic_regex_match "$bobshell_quote_arg" '[A-Za-z0-9_/\-\=]\+'; then
			printf %s "$bobshell_quote_arg"
		else
			bobshell_quote_arg=$(bobshell_replace "$bobshell_quote_arg" "'" "'"'"'"'"'"'"'")
			printf "'%s'" "$bobshell_quote_arg"
		fi
		bobshell_quote_separator=' '
	done
	unset bobshell_quote_arg
}


# fun: bobshell_join SEPARATOR [ITEM...]
bobshell_join() {
	bobshell_join_separator="$1"
	shift
	for bobshell_join_item in "$@"; do
		printf %s "$bobshell_join_item"
		break
	done
	for bobshell_join_item in "$@"; do
		printf %s "$bobshell_join_separator"
		printf %s "$bobshell_join_item"
	done
}



bobshell_strip_left() {
	bobshell_strip_left_value="$1"
	while true; do
		case "$bobshell_strip_left_value" in 
			([[:space:]]*)
				bobshell_strip_left_value="${bobshell_strip_left_value#?}" ;;
			(*) break ;;
		esac
	done
	printf %s "$bobshell_strip_left_value"
}

bobshell_strip_right() {
	bobshell_strip_right_value="$1"
	while true; do
		case "$bobshell_strip_right_value" in 
			(*[[:space:]])
				bobshell_strip_right_value="${bobshell_strip_right_value%?}" ;;
			(*) break ;;
		esac
	done
	printf %s "$bobshell_strip_right_value"
}

bobshell_strip() {
	bobshell_strip_value=$(bobshell_strip_left "$1")
	bobshell_strip_right "$bobshell_strip_value"
}

bobshell_upper_case() {
	printf %s "$*" | awk 'BEGIN { getline; print toupper($0) }'
}

bobshell_lower_case() {
	printf %s "$*" | awk 'BEGIN { getline; print tolower($0) }'
}
