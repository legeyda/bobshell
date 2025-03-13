

shelduck import ./isset.sh

bobshell_array_assert_isset() {
	if ! bobshell_array_isset "$1"; then
		bobshell_die "bobshell_array_foreach: array unset"
	fi
}