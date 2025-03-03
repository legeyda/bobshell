

shelduck import ../../base.sh

# fun: bobshell_code_argv_insert 1 value
bobshell_code_argv_insert() {
	if [ "$1" -gt 9 ]; then
		printf 'bobshell_die "bobshell_code_argv_insert: index > not 9 supported: %s"' "$1"
	fi
	for _bobshell_code_argv_insert__i in $(seq "$1"); do
		printf '_bobshell_code_argv_insert__%s="$%s"\n' "$_bobshell_code_argv_insert__i" "$_bobshell_code_argv_insert__i"
	done
	printf 'shift %s\n' "$_bobshell_code_argv_insert__i"
	printf %s 'set --'
	for _bobshell_code_argv_insert__i in $(seq "$1"); do
		printf ' "$_bobshell_code_argv_insert__%s"' "$_bobshell_code_argv_insert__i"
	done
	printf ' %s "$@"\nunset' "$2"
	for _bobshell_code_argv_insert__i in $(seq "$1"); do
		printf ' _bobshell_code_argv_insert__%s' "$_bobshell_code_argv_insert__i"
	done
	printf '\n'
}