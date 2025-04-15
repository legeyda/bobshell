
shelduck import ../base.sh
shelduck import ../random/int.sh
shelduck import ../result/set.sh
shelduck import ../result/assert.sh
shelduck import ../app.sh
shelduck import ../event/listen.sh


# see https://unix.stackexchange.com/questions/614808/why-is-there-no-mktemp-command-in-posix
bobshell_mktemp() {

	# parse cli
	_bobshell_mktemp__dir=false
	while bobshell_isset_1 "$@"; do
		case "$1" in
			(-d|--directory)
				shift
				_bobshell_mktemp__dir=true
				;;
			(-*)
				bobshell_die "$1: unexpected option"
			(*)
				break
				;;
		esac
	done

	# todo autoclean on exit
	_bobshell_mktemp__root="${TMPDIR:-/tmp}/${bobshell_app_name}"
	mkdir -p "$_bobshell_mktemp__root"


	# generate random name
	while true; do
		bobshell_random_int
		bobshell_result_assert
		_bobshell_mktemp__random="$bobshell_result_2"

		bobshell_random_int
		bobshell_result_assert
		_bobshell_mktemp__random="$_bobshell_mktemp__random$bobshell_result_2"

		bobshell_random_int
		bobshell_result_assert
		_bobshell_mktemp__random="$_bobshell_mktemp__random$bobshell_result_2"

		_bobshell_mktemp__result="$_bobshell_mktemp__root/$_bobshell_mktemp__random"
		if [ ! -e "$_bobshell_mktemp__result" ]; then
			unset _bobshell_mktemp__random
			break
		fi
	done

	# create 
	if [ true = $_bobshell_mktemp__dir ]; then
		mkdir "$_bobshell_mktemp__result"
	else
		touch "$_bobshell_mktemp__result"
	fi
	unset _bobshell_mktemp__dir
	
	bobshell_result_set true "$_bobshell_mktemp__result"
	unset _bobshell_mktemp__result
}