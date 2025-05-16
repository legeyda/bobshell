
shelduck import ../scope.sh

# fun: bobshell_map_unset MAPNAME
bobshell_map_unset() {
	unset "$1"
	bobshell_scope_unset "${1}_"
}