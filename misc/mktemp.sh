
shelduck import ../base.sh
shelduck import ./random.sh
shelduck import ../result/set.sh

# see https://unix.stackexchange.com/questions/614808/why-is-there-no-mktemp-command-in-posix
bobshell_mktemp() {

	# parse cli
	_bobshell_mktemp__dir=false
	_bobshell_mktemp__root="${TMPDIR:-/tmp}"
	while bobshell_isset_1 "$@"; do
		case "$1" in
			(-d|--directory)
				shift
				_bobshell_mktemp__dir=true
				;;
			(*)
				bobshell_die "bobshell_mktemp: unexpected argument: $1"
				;;
		esac
	done

	# generate random name
	while true; do
		_bobshell_mktemp__random=$(bobshell_random)
		_bobshell_mktemp__result="$_bobshell_mktemp__root/$_bobshell_mktemp__random"
		if [ ! -e "$_bobshell_mktemp__result" ]; then
			break
		fi
	done

	# create 
	if [ true = _bobshell_mktemp__dir ]; then
		mkdir "$_bobshell_mktemp__result"
	else
		touch "$_bobshell_mktemp__result"
	fi
	
	bobshell_result_set true "$_bobshell_mktemp__result"
}