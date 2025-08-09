
shelduck import ../base.sh
shelduck import ../str/quote.sh

shelduck import ../event/listen.sh
shelduck import ../event/fire.sh

shelduck import ../var/default.sh
shelduck import ../var/append.sh
shelduck import ./parse.sh


bobshell_event_listen bobshell_cli_setup_start_event '
	unset _bobshell_cli_setup__help

	unset _bobshell_cli_setup__arg_listener

	unset _bobshell_cli_setup__var
	_bobshell_cli_setup__param=false
	_bobshell_cli_setup__flag=false
	
	_bobshell_cli_setup__default_unset=false
	unset _bobshell_cli_setup__default_value

	unset _bobshell_cli_setup__flag_value
	_bobshell_cli_setup__append=false
	_bobshell_cli_setup__separator=	
'

bobshell_event_listen bobshell_cli_setup_clear_event '
	unset _bobshell_cli_setup__help

	unset _bobshell_cli_setup__arg_listener

	unset _bobshell_cli_setup__var
	unset _bobshell_cli_setup__param
	unset _bobshell_cli_setup__flag
	
	unset _bobshell_cli_setup__default_unset
	unset _bobshell_cli_setup__default_value

	unset _bobshell_cli_setup__flag_value
	unset _bobshell_cli_setup__append
	unset _bobshell_cli_setup__separator
	
'

# shellcheck disable=SC2016
bobshell_event_listen bobshell_cli_setup_arg_event '
	case "$1" in
		(h|help|usage)
			_bobshell_cli_setup__help="$2" ;;

		(l|listener)
			_bobshell_cli_setup__arg_listener="$2" ;;

		(v|var|variable)
			_bobshell_cli_setup__var="$2" ;;

		(p|param)
			_bobshell_cli_setup__param=true ;;
		(f|flag)
			_bobshell_cli_setup__flag=true ;;

		(u|default-unset)
			_bobshell_cli_setup__default_unset=true ;;
		(d|default-value)
			_bobshell_cli_setup__default_value="$2" ;;


		(f|flag-value)
			_bobshell_cli_setup__flag_value="$2" ;;
		(a|append)
			_bobshell_cli_setup__append=true ;;
		(s|separator)
			_bobshell_cli_setup__separator="$2" ;;
		
		(*) bobshell_die "bobshell_cli_setup: unknown argument: $1"
	esac
'


bobshell_cli_setup_params='h help usage  l listener   v var variable  d default-value  f flag-value  s separator'
bobshell_cli_setup_flags='p param  f flag  u default-unset  a append'




# fun: bobshell_cli_setup
# use: bobshell_cli_setup SCOPE --usage 'blabla usage' --param --var=VARNAME --default-unset
#
# use: bobshell_cli_setup SCOPE --param --listener='var_param="$1"' p param
# use: bobshell_cli_setup SCOPE --flag  --listener='var_flag=true'  f flag
#
# use: bobshell_cli_setup SCOPE --param --var=VARNAME (--default-unset|--default-value=blablavalue) --append
# use: bobshell_cli_setup SCOPE --param --var=VARNAME (--default-unset|--default-value=blablavalue) --append
# use: bobshell_cli_setup SCOPE --flag  --var=VARNAME [--default-value=false] [--flag-value=true]
#
#
# Usage: [COMMON OPTIONS] (PARAM OPTIONS|FLAG OPTIONS) [ARGS]
# COMMON OPTIONS:
#     -h, -?, --help, --usage
#       show usage and exit
#
#     -p, --param
#       flag indicating param
#     -f, --flag
#       flag indicating flag
#
#     -l, --listener=LISTENERSCRIPT
#       define argument listener (param or flag)
#
#     -v, --var, --variable=VARIABLENAME
#       variable name to store flag value or param value
#     --default-value=VALUE
#       default 'false' for flags, undefined for params
#     --default-unset
#       default true for params, n/a for flags
#     --flag-value=FLAGVALUE
#       value to write to variable if flag is passed, default true, implies --flag, not compatible with --param
#     
#
#
# FLAG OPTIONS:

#
#
#
#
#
#
#
#
bobshell_cli_setup() {
	_bobshell_cli_setup__scope="$1"
	shift


	bobshell_cli_parse bobshell_cli_setup "$@"

	# VALIDATE NAMED ARGUMENTS
	if [ false = "$_bobshell_cli_setup__param" ] && [ false = "$_bobshell_cli_setup__flag" ]; then
		bobshell_die "bobshell_cli_setup: either --param or --flag required"
	fi

	if [ true = "$_bobshell_cli_setup__param" ] && [ true = "$_bobshell_cli_setup__flag" ]; then
		bobshell_die "bobshell_cli_setup: both --param or --flag forbidden"
	fi

	if ! bobshell_isset _bobshell_cli_setup__arg_listener && ! bobshell_isset _bobshell_cli_setup__var; then
		bobshell_die "bobshell_cli_setup: either --listener or --var required"
	fi

	if bobshell_isset _bobshell_cli_setup__arg_listener && bobshell_isset _bobshell_cli_setup__var; then
		bobshell_die "bobshell_cli_setup: both --listener and --var forbidden"
	fi

	if bobshell_isset _bobshell_cli_setup__var; then
		if ! bobshell_regex_match "$_bobshell_cli_setup__var" '[A-Za-z_][A-Za-z0-9_]*'; then
			bobshell_die "bobshell_cli_setup: malformed var name: $_bobshell_cli_setup__var"
		fi

	fi

	if bobshell_isset _bobshell_cli_setup__default_value && [ true = "$_bobshell_cli_setup__default_unset" ]; then
		bobshell_die "bobshell_cli_setup: both --default-value and --default-unset forbidden"
	fi

	if [ false = "$_bobshell_cli_setup__flag" ] && bobshell_isset _bobshell_cli_setup__flag_value; then
		bobshell_die "bobshell_cli_setup: --flag-value without --flag"
	fi

	# LISTENER --listener
	if bobshell_isset _bobshell_cli_setup__arg_listener; then
		bobshell_event_listen "$_bobshell_cli_setup__scope"_arg_event "$_bobshell_cli_setup__arg_listener"
	fi

	# VALIDATE POSITIONAL ARGUMENTS
	shift "$bobshell_cli_shift"
	if ! bobshell_isset_1 "$@"; then
		bobshell_die "bobshell_cli_setup: at least one positional argument expected"
	fi
	for _bobshell_cli_setup__i in "$@"; do
		if ! bobshell_regex_match "$_bobshell_cli_setup__i" '[A-Za-z0-9][-A-Za-z0-9]*'; then
			bobshell_die "bobshell_cli_setup: malformed option: $_bobshell_cli_setup__i"
		fi
	done
	unset _bobshell_cli_setup__i

	# 	
	if [ true = "$_bobshell_cli_setup__param" ]; then
		bobshell_var_default "$_bobshell_cli_setup__scope"_params ''
		bobshell_var_append  "$_bobshell_cli_setup__scope"_params " $*"
		
	elif [ true = "$_bobshell_cli_setup__flag" ]; then
		bobshell_var_default "$_bobshell_cli_setup__scope"_flags ''
		bobshell_var_append  "$_bobshell_cli_setup__scope"_flags  " $*"
	else
		bobshell_die 'dev assertion failed'
	fi


	# shellcheck disable=SC2016
	bobshell_event_listen "$_bobshell_cli_setup__scope"_help_event '
printf %s "  "
_bobshell_cli_setup_help_event__separator=
for x in '"$*"'; do
	printf "%s" "$_bobshell_cli_setup_help_event__separator"
	_bobshell_cli_setup_help_event__separator=", "
	if [ 1 = ${#x} ]; then
		printf -- "-%s" "$x"
	else
		printf -- "--%s" "$x"
	fi
done
unset _bobshell_cli_setup_help_event__separator
if [ true = '"$_bobshell_cli_setup__param"' ]; then
	printf "%s" =VALUE 
fi
printf "\n"
'
	if bobshell_isset _bobshell_cli_setup__help; then
		bobshell_str_quote "$_bobshell_cli_setup__help"
		bobshell_event_listen "$_bobshell_cli_setup__scope"_help_event '
printf "    %s\n" '"$bobshell_result_1"
	fi


	if bobshell_isset _bobshell_cli_setup__arg_listener; then
		# shellcheck disable=SC2016
		bobshell_event_listen "$_bobshell_cli_setup__scope"_arg_event '
if bobshell_equals_any "$1" '"$*"'; then
	'"$_bobshell_cli_setup__arg_listener"'
fi'

	elif bobshell_isset _bobshell_cli_setup__var; then


		if bobshell_isset _bobshell_cli_setup__default_value; then
			bobshell_str_quote "$_bobshell_cli_setup__default_value"
			bobshell_event_listen "$_bobshell_cli_setup__scope"_start_event "$_bobshell_cli_setup__var=$bobshell_result_1"
		elif [ true = "$_bobshell_cli_setup__default_unset" ]; then
			bobshell_event_listen "$_bobshell_cli_setup__scope"_start_event "unset $_bobshell_cli_setup__var"
		elif [ true = "$_bobshell_cli_setup__flag" ]; then
			bobshell_event_listen "$_bobshell_cli_setup__scope"_start_event "$_bobshell_cli_setup__var=false"
		elif [ true = "$_bobshell_cli_setup__param" ]; then
			bobshell_event_listen "$_bobshell_cli_setup__scope"_start_event "unset $_bobshell_cli_setup__var"
		fi

		if [ true = "$_bobshell_cli_setup__param" ]; then
			if bobshell_isset _bobshell_cli_setup__flag_value; then
				bobshell_die "bobshell_cli_setup: --param and --flag-value"
			fi

			if [ true = "$_bobshell_cli_setup__append" ]; then
				bobshell_str_quote "$_bobshell_cli_setup__separator"
				bobshell_result_read _bobshell_cli_setup__quoted_separator

				# shellcheck disable=SC2016
				bobshell_event_listen "$_bobshell_cli_setup__scope"_arg_event '
if bobshell_equals_any "$1" '"$*"'; then
	if [ -n "${'"$_bobshell_cli_setup__var"':-}" ]; then
		'"$_bobshell_cli_setup__var"'="${'"$_bobshell_cli_setup__var"':-}"'"$_bobshell_cli_setup__quoted_separator"'
	fi
	'"$_bobshell_cli_setup__var"'="${'"$_bobshell_cli_setup__var"':-}$2"
fi'
			else
				# shellcheck disable=SC2016
				bobshell_event_listen "$_bobshell_cli_setup__scope"_arg_event '
if bobshell_equals_any "$1" '"$*"'; then
	'"$_bobshell_cli_setup__var"'="$2"
fi'				
				unset _bobshell_cli_setup__quoted_separator
			fi
			unset _bobshell_cli_setup__param_value

		elif [ true = "$_bobshell_cli_setup__flag" ]; then
			if bobshell_isset _bobshell_cli_setup__flag_value; then
				_bobshell_cli_setup__actual_flag_value="$_bobshell_cli_setup__flag_value"
			else
				_bobshell_cli_setup__actual_flag_value=true
			fi

			bobshell_str_quote "$_bobshell_cli_setup__actual_flag_value"
			bobshell_result_read _bobshell_cli_setup__quoted_actual_flag_value

			if [ true = "$_bobshell_cli_setup__append" ]; then
				bobshell_str_quote "$_bobshell_cli_setup__separator"
				bobshell_result_read _bobshell_cli_setup__quoted_separator


				# shellcheck disable=SC2016
				bobshell_event_listen "$_bobshell_cli_setup__scope"_arg_event '
if bobshell_equals_any "$1" '"$*"'; then
	if [ -n "${'"$_bobshell_cli_setup__var"':-}" ]; then
		'"$_bobshell_cli_setup__var"'="${'"$_bobshell_cli_setup__var"':-}"'"$_bobshell_cli_setup__quoted_separator"'
	fi
	'"$_bobshell_cli_setup__var"'="${'"$_bobshell_cli_setup__var"'}"'"$_bobshell_cli_setup__quoted_actual_flag_value"'
fi'
				unset _bobshell_cli_setup__quoted_separator
			else
				bobshell_str_quote "$_bobshell_cli_setup__actual_flag_value$_bobshell_cli_setup__separator"
				# shellcheck disable=SC2016
				bobshell_event_listen "$_bobshell_cli_setup__scope"_arg_event '
if bobshell_equals_any "$1" '"$*"'; then
	'"$_bobshell_cli_setup__var"'="'"$bobshell_result_1"'"
fi'
			fi
			unset _bobshell_cli_setup__actual_flag_value _bobshell_cli_setup__quoted_actual_flag_value
		else
			bobshell_die "dev assertion faled"
		fi
		bobshell_event_listen "${_bobshell_cli_setup__scope}_clear" "unset $_bobshell_cli_setup__var" 
	else
		bobshell_die "bobshell_cli_setup: both --listener and --var forbidden"
	fi

	# CLEAR
	unset _bobshell_cli_setup__scope
	bobshell_event_fire bobshell_cli_setup_clear_event

}

