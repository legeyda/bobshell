
shelduck import ../base.sh

# fun: bobshell_in VALUES...
bobshell_all_equal() {
	if ! bobshell_isset_2 "$@"; then
		bobshell_die 'bobshell_all_equal: at least two arguments expected'
	fi
	while bobshell_isset_2 "$@"; do
		if [ "$1" != "$2" ]; then
			return 1
		fi
		shift
	done
	return 0
}