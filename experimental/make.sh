
# fun: bobshell_make BUILDFILE --dependency=DEPFILE -d ANOTHERDEPFILE -- CMD [ARGS ... ]
# fun: bobshell_make BUILDFILE [ DEPFILE ... ] -- CMD [ARGS ... ]
# bobshell_cli_setup bobshell_make_cli --param --listener='bobshell_make_rule_dep "$1"' d dependency
# bobshell_make_rule_dep() {
# 	bobshell_str_quote "$@"
# 	_bobshell_make_rule__deps="${_bobshell_make_rule__deps:-} $bobshell_result_1"
# }

shelduck import ../base.sh
shelduck import ../event/listen.sh
shelduck import ../event/fire.sh
shelduck import ../event/stop.sh
shelduck import ../result/assert.sh

bobshell_make_rule() {
	# todo check for duplicates

	# unset _bobshell_make_rule__deps
	# bobshell_cli_parse bobshell_make_cli "$@"
	# shift "$bobshell_cli_shift"

	if [ "${1:-}" = '--phony' ]; then
		_bobshell_make_rule__phony=true
		shift
	else
		_bobshell_make_rule__phony=false
	fi

	_bobshell_make_rule__target="$1"
	shift

	bobshell_str_quote "$_bobshell_make_rule__target"
	_bobshell_make_rule__quoted_target="$bobshell_result_1"

	# parse deps
	_bobshell_make_rule__deps=
	while [ "$#" -gt 0 ]; do
		if [ -- = "$1" ]; then
			break
		fi

		if [ "$1" = "$_bobshell_make_rule__target" ]; then
			bobshell_die circular dependency on itself: "$1 -> $1"
		fi

		bobshell_str_quote "$1"
		_bobshell_make_rule__deps="$_bobshell_make_rule__deps $bobshell_result_1"
		shift
	done

	if [ "${1:-}" != -- ]; then
		bobshell_die bobshell_make_rule: -- expected
	fi
	shift

	if [ "$#" -eq 0 ]; then
		bobshell_die bobshell_make_rule: -- cmd expected
	fi


	bobshell_args_to_script "$@"
	bobshell_result_assert _bobshell_make_rule__script -- empty rule script

	# событие проверить существование правила
	bobshell_event_listen bobshell_make_search_event eval '
if [ "$1" = '"$_bobshell_make_rule__quoted_target"' ]; then
	_bobshell_make_search__found=true
	bobshell_event_stop
fi
'

	bobshell_event_listen bobshell_make_recurse_event eval '
if [ "$1" = '"$_bobshell_make_rule__quoted_target"' ]; then
	_bobshell_make_search__found=true
	bobshell_event_stop
fi
'





	_bobshell_make_rule__listener='if [ "$1" = '"$_bobshell_make_rule__quoted_target"' ]; then
	# build dependencies
	for _bobshell_make_rule__i in '"$_bobshell_make_rule__deps"'; do
		bobshell_make_build "$_bobshell_make_rule__i"
	done
	unset _bobshell_make_rule__i
'

	_bobshell_make_rule__script_do_build='
	# run build script
	set -- "$1" '"$_bobshell_make_rule__deps"'
	'"$_bobshell_make_rule__script"'
	set -- "$1"
'


	if [ true = "$_bobshell_make_rule__phony" ]; then

	_bobshell_make_rule__listener="$_bobshell_make_rule__listener"'
	'"$_bobshell_make_rule__script_do_build"'
'

	else

		_bobshell_make_rule__listener="$_bobshell_make_rule__listener"'
	if [ -e "$1" ]; then
		_bobshell_make_rule__pending=false
		for _bobshell_make_rule__i in '"$_bobshell_make_rule__deps"'; do
			if ! [ -f "$_bobshell_make_rule__i" ] || [ "$_bobshell_make_rule__i" -nt "$1" ]; then
				_bobshell_make_rule__pending=true
				break
			fi
		done
		unset _bobshell_make_rule__i
	else
		_bobshell_make_rule__pending=true
	fi

	if [ true = "$_bobshell_make_rule__pending" ]; then
		'"$_bobshell_make_rule__script_do_build"'
	fi
	unset _bobshell_make_rule__pending
'

	fi
	unset _bobshell_make_rule__script_do_build _bobshell_make_rule__phony

	_bobshell_make_rule__listener="$_bobshell_make_rule__listener"'
	bobshell_event_stop
fi
'

	bobshell_event_listen bobshell_make_build_event eval "$_bobshell_make_rule__listener"
	unset _bobshell_make_rule__listener
}


bobshell_args_to_script() {
	if [ $# -eq 0 ]; then
		bobshell_result_set false no arguments
	elif [ eval = "$1" ]; then
		shift
		bobshell_result_set true "$*"
	else
		bobshell_str_quote "$@"
		bobshell_result_set true "$bobshell_result_1"
	fi
}


bobshell_make_build() {
	#printf %s "==================================DEBUG: bobshel_make_build $*"
	while [ "$#" -eq 0 ]; do
		bobshell_die bobshell_make_build: args expected
	done

	# сначала проверим что для всех целей существуют правила, прежде чем собирать зависимости
	for _bobshell_make_build__target in "$@"; do
		_bobshell_make_search__found=false
		bobshell_event_fire bobshell_make_search_event "$_bobshell_make_build__target"
		if [ true != "$_bobshell_make_search__found" ]; then
			if ! [ -e "$_bobshell_make_build__target" ]; then
				bobshell_die bobshell_make_build: no build rule for "$_bobshell_make_build__target"
			fi
		fi
		unset _bobshell_make_search__found
	done
	unset _bobshell_make_build__target

	# сборка для всех целей
	for _bobshell_make_build__target in "$@"; do
		bobshell_event_fire bobshell_make_build_event "$_bobshell_make_build__target"
	done
	unset _bobshell_make_build__target
}
