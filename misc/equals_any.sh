

shelduck import ../base.sh

bobshell_equals_any() {
	if ! bobshell_isset_2 "$@"; then
		return 1
	elif ! bobshell_isset_3 "$@"; then
		if [ "$1" = "$2" ]; then
			return 0
		else
			return 1
		fi
	fi
	bobshell_equals_value="$1"
	shift
	while bobshell_isset_1 "$@"; do
		if [ "$bobshell_equals_value" = "$1" ];  then
			return
		fi
		shift
	done
	unset bobshell_equals_value
	return 1
}