
shelduck import base.sh
shelduck import string.sh
shelduck import resource/copy.sh


# fun: bobshell_interpolate TEMPLATE DESTINATION
# use: VALUE=hello; echo 'msg is $VALUE' | bobshell_interpolate stdin: stdout: # gives: msg is hello
bobshell_interpolate() {
	bobshell_interpolate_data=
	bobshell_resource_copy "$1" var:bobshell_interpolate_data

	# shellcheck disable=SC2034
	bobshell_interpolate_result=$(eval "cat <<EOF
$bobshell_interpolate_data
EOF
")
	unset bobshell_interpolate_data

	bobshell_resource_copy var:bobshell_interpolate_result "$2"
	unset bobshell_interpolate_result
}



# fun: mustache [-s|--scope SCOPE] TEMPLATE DESTINATION
bobshell_mustache() {
	bobshell_mustache_scope=
	while bobshell_isset_1 "$@"; do
		case "$1" in
			(-s|--scope)
				shift
				bobshell_isset_1 "$@" || bobshell_die "scope required"
				bobshell_mustache_scope="$1"
				shift
				;;
			(*)	break;;
		esac
	done

	bobshell_isset_1 "$@" || bobshell_die "source required"
	bobshell_mustache_input=
	bobshell_resource_copy "$1" var:bobshell_mustache_input
	shift
	
	bobshell_isset_1 "$@" || bobshell_die "destination required"

	bobshell_mustache_result=
	while bobshell_split_first "$bobshell_mustache_input" '{{' bobshell_mustache_before bobshell_mustache_input; do
		bobshell_mustache_result="$bobshell_mustache_result$bobshell_mustache_before"
		if ! bobshell_split_first "$bobshell_mustache_input" '}}' bobshell_mustache_before bobshell_mustache_input; then
			bobshell_die "unclosed bracket"
		fi
		bobshell_mustache_name=$(bobshell_strip "$bobshell_mustache_before")
		bobshell_mustache_value=$(bobshell_getvar "$bobshell_mustache_scope$bobshell_mustache_name")
		bobshell_mustache_result="$bobshell_mustache_result$bobshell_mustache_value"
		unset bobshell_mustache_before bobshell_mustache_name bobshell_mustache_value
	done
	bobshell_mustache_result="$bobshell_mustache_result$bobshell_mustache_input"

	bobshell_resource_copy var:bobshell_mustache_result "$1"
	unset bobshell_mustache_scope bobshell_mustache_input bobshell_mustache_result
}

