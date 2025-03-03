


shelduck import ../string.sh

# major, minor, patch, pre, meta
bobshell_semver_parse() {
	unset bobshell_semver_parse_major bobshell_semver_parse_minor bobshell_semver_parse_patch
	unset bobshell_semver_parse_pre bobshell_semver_parse_meta

	if ! bobshell_split_first "$1" . bobshell_semver_parse_major _bobshell_semver_parse_rest; then
		bobshell_semver_parse_major="$1"
	elif ! bobshell_split_first "$_bobshell_semver_parse_rest" . bobshell_semver_parse_minor _bobshell_semver_parse_rest; then
		bobshell_semver_parse_minor="$_bobshell_semver_parse_rest"
	elif ! bobshell_split_first "$_bobshell_semver_parse_rest" - bobshell_semver_parse_patch _bobshell_semver_parse_rest; then
		bobshell_semver_parse_patch="$_bobshell_semver_parse_rest"
	elif ! bobshell_split_first "$_bobshell_semver_parse_rest" + bobshell_semver_parse_pre bobshell_semver_parse_meta; then
		bobshell_semver_parse_pre="$_bobshell_semver_parse_rest"
	fi
	unset _bobshell_semver_parse_rest
}

