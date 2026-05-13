
shelduck import ../base.sh
shelduck import ../eval.sh
shelduck import ../str/quote.sh

shelduck import ../event/listen.sh
shelduck import ../event/fire.sh

shelduck import ../var/default.sh
shelduck import ../var/append.sh
shelduck import ./parse.sh


bobshell_event_listen bobshell_cli_param_start_event '
	unset _bobshell_cli_param__help

	unset _bobshell_cli_param__var
	_bobshell_cli_param__param=false
	_bobshell_cli_param__flag=false
	
	_bobshell_cli_param__default_unset=false
	unset _bobshell_cli_param__default_value

	unset _bobshell_cli_param__flag_value

	unset _bobshell_cli_param__listener
	_bobshell_cli_param__append=false
	_bobshell_cli_param__separator=	
'

bobshell_event_listen bobshell_cli_param_clear_event '
	unset _bobshell_cli_param__help


	unset _bobshell_cli_param__var
	unset _bobshell_cli_param__param
	unset _bobshell_cli_param__flag
	
	unset _bobshell_cli_param__default_unset
	unset _bobshell_cli_param__default_value

	unset _bobshell_cli_param__flag_value

	unset _bobshell_cli_param__listener
	unset _bobshell_cli_param__append
	unset _bobshell_cli_param__separator
	
'

# shellcheck disable=SC2016
bobshell_event_listen bobshell_cli_param_arg_event '
	case "$1" in
		(h|help|usage)
			_bobshell_cli_param__help="$2" ;;

		(p|param)
			_bobshell_cli_param__param=true ;;
		(f|flag)
			_bobshell_cli_param__flag=true ;;

		(u|default-unset)
			_bobshell_cli_param__default_unset=true ;;
		(d|default-value)
			_bobshell_cli_param__default_value="$2" ;;


		(f|flag-value)
			_bobshell_cli_param__flag_value="$2" ;;
		(l|listener)
			_bobshell_cli_param__listener="$2" ;;
		(a|append)
			_bobshell_cli_param__append=true ;;
		(s|separator)
			_bobshell_cli_param__separator="$2" ;;
		
		(*) bobshell_die "bobshell_cli_param: unknown argument: $1"
	esac
'


bobshell_cli_param_params='h help usage  l listener   v var variable  d default-value  f flag-value  s separator'
bobshell_cli_param_flags='p param  f flag  u default-unset  a append'



# bobshell_cli_param SCOPENAME LISTENERSCRIPT [ARGS...]
bobshell_cli_param() {
	if [ "$#" -lt 2 ]; do
		bobshell_die 'at least three arguments expected: scope, listener, option'
	done

	_bobshell_cli_param__scope="$1"
	_bobshell_cli_param__script="$2"
	shift 2



	while [ "$#" -gt 1 ]; do
		all_params="${all_params:-} $1"
		shift
	done

	for _bobshell_cli_param__i in "$@"; do
		if ! bobshell_regex_match "$_bobshell_cli_param__i" '[A-Za-z0-9][-A-Za-z0-9]*'; then
			bobshell_die "bobshell_cli_param: malformed option: $_bobshell_cli_param__i"
		fi
	done















	bobshell_cli_parse bobshell_cli_param "$@"

	# VALIDATE NAMED ARGUMENTS
	if [ false = "$_bobshell_cli_param__param" ] && [ false = "$_bobshell_cli_param__flag" ]; then
		bobshell_die "bobshell_cli_param: either --param or --flag required"
	fi

	if [ true = "$_bobshell_cli_param__param" ] && [ true = "$_bobshell_cli_param__flag" ]; then
		bobshell_die "bobshell_cli_param: both --param or --flag forbidden"
	fi

	if ! bobshell_isset _bobshell_cli_param__listener && ! bobshell_isset _bobshell_cli_param__var; then
		bobshell_die "bobshell_cli_param: either --listener or --var required"
	fi


	if bobshell_isset _bobshell_cli_param__var; then
		if ! bobshell_regex_match "$_bobshell_cli_param__var" '[A-Za-z_][A-Za-z0-9_]*'; then
			bobshell_die "bobshell_cli_param: malformed var name: $_bobshell_cli_param__var"
		fi

	fi

	if bobshell_isset _bobshell_cli_param__default_value && [ true = "$_bobshell_cli_param__default_unset" ]; then
		bobshell_die "bobshell_cli_param: both --default-value and --default-unset forbidden"
	fi

	if [ false = "$_bobshell_cli_param__flag" ] && bobshell_isset _bobshell_cli_param__flag_value; then
		bobshell_die "bobshell_cli_param: --flag-value without --flag"
	fi

	# VALIDATE POSITIONAL ARGUMENTS
	shift "$bobshell_cli_shift"
	if ! bobshell_isset_1 "$@"; then
		bobshell_die "bobshell_cli_param: at least one positional argument expected"
	fi
	for _bobshell_cli_param__i in "$@"; do
		if ! bobshell_regex_match "$_bobshell_cli_param__i" '[A-Za-z0-9][-A-Za-z0-9]*'; then
			bobshell_die "bobshell_cli_param: malformed option: $_bobshell_cli_param__i"
		fi
	done
	unset _bobshell_cli_param__i

	# 	
	if [ true = "$_bobshell_cli_param__param" ]; then
		bobshell_var_default "$_bobshell_cli_param__scope"_params ''
		bobshell_var_append  "$_bobshell_cli_param__scope"_params " $*"
		
	elif [ true = "$_bobshell_cli_param__flag" ]; then
		bobshell_var_default "$_bobshell_cli_param__scope"_flags ''
		bobshell_var_append  "$_bobshell_cli_param__scope"_flags  " $*"
	else
		bobshell_die 'dev assertion failed'
	fi


	# shellcheck disable=SC2016
	bobshell_event_listen "$_bobshell_cli_param__scope"_help_event '
printf %s "  "
_bobshell_cli_param_help_event__separator=
for x in '"$*"'; do
	printf "%s" "$_bobshell_cli_param_help_event__separator"
	_bobshell_cli_param_help_event__separator=", "
	if [ 1 = ${#x} ]; then
		printf -- "-%s" "$x"
	else
		printf -- "--%s" "$x"
	fi
done
unset _bobshell_cli_param_help_event__separator
if [ true = '"$_bobshell_cli_param__param"' ]; then
	printf "%s" =VALUE 
fi
printf "\n"
'
	if bobshell_isset _bobshell_cli_param__help; then
		bobshell_str_quote "$_bobshell_cli_param__help"
		bobshell_event_listen "$_bobshell_cli_param__scope"_help_event '
printf "    %s\n" '"$bobshell_result_1"
	fi


	if bobshell_isset _bobshell_cli_param__listener; then
		if [ true = "$_bobshell_cli_param__param" ]; then
			# todo check param value provided
			# shellcheck disable=SC2016
			bobshell_event_listen "$_bobshell_cli_param__scope"_arg_event '
if bobshell_equals_any "$1" '"$*"'; then
	bobshell_eval '"'val:$_bobshell_cli_param__listener'"' "$2"
fi'
		else
			if bobshell_isset _bobshell_cli_param__flag_value; then
				_bobshell_cli_param__actual_flag_value="$_bobshell_cli_param__flag_value"
			else
				_bobshell_cli_param__actual_flag_value=true
			fi
			bobshell_str_quote "$_bobshell_cli_param__actual_flag_value$_bobshell_cli_param__separator"
			# shellcheck disable=SC2016
			bobshell_event_listen "$_bobshell_cli_param__scope"_arg_event '
if bobshell_equals_any "$1" '"$*"'; then
	bobshell_eval '"'val:$_bobshell_cli_param__listener'"' "'"$bobshell_result_1"'"
fi'
		fi

	fi
	
	
	if bobshell_isset _bobshell_cli_param__var; then


		if bobshell_isset _bobshell_cli_param__default_value; then
			bobshell_str_quote "$_bobshell_cli_param__default_value"
			bobshell_event_listen "$_bobshell_cli_param__scope"_start_event "$_bobshell_cli_param__var=$bobshell_result_1"
		elif [ true = "$_bobshell_cli_param__default_unset" ]; then
			bobshell_event_listen "$_bobshell_cli_param__scope"_start_event "unset $_bobshell_cli_param__var"
		elif [ true = "$_bobshell_cli_param__flag" ]; then
			bobshell_event_listen "$_bobshell_cli_param__scope"_start_event "$_bobshell_cli_param__var=false"
		elif [ true = "$_bobshell_cli_param__param" ]; then
			bobshell_event_listen "$_bobshell_cli_param__scope"_start_event "unset $_bobshell_cli_param__var"
		fi

		if [ true = "$_bobshell_cli_param__param" ]; then
			if bobshell_isset _bobshell_cli_param__flag_value; then
				bobshell_die "bobshell_cli_param: --param and --flag-value"
			fi

			if [ true = "$_bobshell_cli_param__append" ]; then
				bobshell_str_quote "$_bobshell_cli_param__separator"
				bobshell_result_read _bobshell_cli_param__quoted_separator

				# shellcheck disable=SC2016
				bobshell_event_listen "$_bobshell_cli_param__scope"_arg_event '
if bobshell_equals_any "$1" '"$*"'; then
	if [ -n "${'"$_bobshell_cli_param__var"':-}" ]; then
		'"$_bobshell_cli_param__var"'="${'"$_bobshell_cli_param__var"':-}"'"$_bobshell_cli_param__quoted_separator"'
	fi
	'"$_bobshell_cli_param__var"'="${'"$_bobshell_cli_param__var"':-}$2"
fi'
				unset _bobshell_cli_param__quoted_separator
			else
				# shellcheck disable=SC2016
				bobshell_event_listen "$_bobshell_cli_param__scope"_arg_event '
if bobshell_equals_any "$1" '"$*"'; then
	'"$_bobshell_cli_param__var"'="$2"
fi'
			fi
			unset _bobshell_cli_param__param_value

		elif [ true = "$_bobshell_cli_param__flag" ]; then
			if bobshell_isset _bobshell_cli_param__flag_value; then
				_bobshell_cli_param__actual_flag_value="$_bobshell_cli_param__flag_value"
			else
				_bobshell_cli_param__actual_flag_value=true
			fi

			bobshell_str_quote "$_bobshell_cli_param__actual_flag_value"
			bobshell_result_read _bobshell_cli_param__quoted_actual_flag_value



			if [ true = "$_bobshell_cli_param__append" ]; then
				bobshell_str_quote "$_bobshell_cli_param__separator"
				bobshell_result_read _bobshell_cli_param__quoted_separator


				# shellcheck disable=SC2016
				bobshell_event_listen "$_bobshell_cli_param__scope"_arg_event '
if bobshell_equals_any "$1" '"$*"'; then
	if [ -n "${'"$_bobshell_cli_param__var"':-}" ]; then
		'"$_bobshell_cli_param__var"'="${'"$_bobshell_cli_param__var"':-}"'"$_bobshell_cli_param__quoted_separator"'
	fi
	'"$_bobshell_cli_param__var"'="${'"$_bobshell_cli_param__var"'}"'"$_bobshell_cli_param__quoted_actual_flag_value"'
fi'
				unset _bobshell_cli_param__quoted_separator
			else
				bobshell_str_quote "$_bobshell_cli_param__actual_flag_value$_bobshell_cli_param__separator"
				# shellcheck disable=SC2016
				bobshell_event_listen "$_bobshell_cli_param__scope"_arg_event '
if bobshell_equals_any "$1" '"$*"'; then
	'"$_bobshell_cli_param__var"'="'"$bobshell_result_1"'"
fi'
			fi
			unset _bobshell_cli_param__actual_flag_value _bobshell_cli_param__quoted_actual_flag_value
		else
			bobshell_die "dev assertion faled"
		fi
		bobshell_event_listen "${_bobshell_cli_param__scope}_clear" "unset $_bobshell_cli_param__var" 
	fi

	# CLEAR
	unset _bobshell_cli_param__scope
	bobshell_event_fire bobshell_cli_param_clear_event

}

