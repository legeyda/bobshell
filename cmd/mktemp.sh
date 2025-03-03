
shelduck import ../base.sh
shelduck ./random.sh

# see https://unix.stackexchange.com/questions/614808/why-is-there-no-mktemp-command-in-posix
bobshell_mktemp() {
	# delegate to builtin if available
	if command_available mktemp; then
		mktemp "$@"
		return
	fi

	# parse cli
	_bobshell_mktemp__cli_create_dir=false
	_bobshell_mktemp__cli_temp_root="${TMPDIR:-/tmp}"
	while bobshell_isset_1 "$@"; do
		case "$1" in
			(-d|--directory)
				shift
				_bobshell_mktemp__cli_directory=true
				;;
			(-p|--tmpdir)
				_bobshell_mktemp__cli_temp_root="$2"
				shift 2
				;;
			(*)
				bobshell_die "bobshell_mktemp: unexpected argument: $1"
				;;
		esac
	done

	# generate random name
	while true; do
		_bobshell_mktemp__random=$(bobshell_random)
		_bobshell_mktemp__result="$_bobshell_mktemp__cli_temp_root/$_bobshell_mktemp__random"
		if [ ! -e "$_bobshell_mktemp__result" ]; then
			break
		fi
	done

	# create 
	if [ false = _bobshell_mktemp__cli_create_dir ]; then
		touch "$_bobshell_mktemp__result"
	else
		mkdir "$_bobshell_mktemp__result"
	fi
	
	printf '%s\n' "$_bobshell_mktemp__result"
}