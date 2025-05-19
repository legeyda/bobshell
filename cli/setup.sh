
shelduck import ../base.sh
shelduck import ../str/quote.sh

shelduck import ../event/listen.sh
shelduck import ../event/fire.sh

shelduck import ./param.sh
shelduck import ./flag.sh





bobshell_event_listen bobshell_cli_setup_cli_start 'unset _bobshell_cli_setup__usage _bobshell_cli_setup__var _bobshell_cli_setup__default_value _bobshell_cli_setup__flag_value
_bobshell_cli_setup__default_unset=false
_bobshell_cli_setup__param=false
_bobshell_cli_setup__flag=false
'

bobshell_cli_param bobshell_cli_setup_cli _bobshell_cli_setup__usage usage
bobshell_cli_param bobshell_cli_setup_cli _bobshell_cli_setup__var v var variable

bobshell_cli_flag  bobshell_cli_setup_cli _bobshell_cli_setup__default_unset true u default-unset
bobshell_cli_param bobshell_cli_setup_cli _bobshell_cli_setup__default_value d default-value

bobshell_cli_flag  bobshell_cli_setup_cli _bobshell_cli_setup__param true p param
bobshell_cli_flag  bobshell_cli_setup_cli _bobshell_cli_setup__flag  true f flag
bobshell_cli_param bobshell_cli_setup_cli _bobshell_cli_setup__flag_value f flag-value


# fun: bobshell_cli_setup
# use: bobshell_cli_setup --usage 'blablausage' --var=VARNAME --param --default-unset
bobshell_cli_setup() {

	_bobshell_cli_setup__scope="$1"
	shift
	bobshell_cli_parse bobshell_cli_setup_cli "$@"
	shift "$bobshell_cli_shift"

	bobshell_cli_setup_validate "$@"

	# USAGE
	bobshell_str_quote "$_bobshell_cli_setup__usage"
	bobshell_event_listen "${_bobshell_cli_setup__scope}_usage" "printf %s '$bobshell_result_1'" 
	
	# variable initial value
	if [ true = "$_bobshell_cli_setup__default_unset" ]; then
		bobshell_event_listen "${_bobshell_cli_setup__scope}_start" "unset $_bobshell_cli_setup__var" 
	elif bobshell_isset _bobshell_cli_setup__default_value; then
		bobshell_str_quote "$_bobshell_cli_setup__default_value"
		bobshell_event_listen "${_bobshell_cli_setup__scope}_start" "$_bobshell_cli_setup__var=$bobshell_result_1" 
	fi

	# variable dest value
	if [ true = "$_bobshell_cli_setup__param" ]; then
		bobshell_cli_param "$_bobshell_cli_setup__scope" "$_bobshell_cli_setup__var" "$@"
	elif bobshell_isset _bobshell_cli_setup__flag_value; then
		bobshell_cli_flag  "$_bobshell_cli_setup__scope" "$_bobshell_cli_setup__var" "$_bobshell_cli_setup__flag_value" "$@"
	else
		bobshell_die 'either --param or --flag-value required'
	fi

	# clear
	bobshell_event_listen "${_bobshell_cli_setup__scope}_clear" "unset $_bobshell_cli_setup__var" 

	unset _bobshell_cli_setup__scope
	bobshell_event_fire bobshell_cli_setup_cli_start
}



bobshell_cli_setup_validate() {
	# POSITIONAL ARGUMENTS
	if ! bobshell_isset_1 "$@"; then
		bobshell_die 'bobshell_cli_setup: at last one positional argument expected'
	fi
	for _bobshell_cli_setup__arg in "$@"; do
		if ! bobshell_regex_match "$_bobshell_cli_setup__arg" '[A-Za-z0-9][-A-Za-z0-9]*'; then
			bobshell_die 'bobshell_cli_setup: malformed option'
		fi
	done

	# USAGE
	if ! bobshell_isset _bobshell_cli_setup__usage; then
		_bobshell_cli_setup__usage=$(printf '\t')
		for _bobshell_cli_setup__arg in "$@"; do
			if [ 1 = "${#_bobshell_cli_setup__arg}" ]; then
				_bobshell_cli_setup__usage="$_bobshell_cli_setup__usage -$_bobshell_cli_setup__arg "
			else
				_bobshell_cli_setup__usage="$_bobshell_cli_setup__usage --$_bobshell_cli_setup__arg "
			fi
		done
	fi

	# VARIABLE
	if ! bobshell_isset _bobshell_cli_setup__var; then
		bobshell_die 'var required'
	fi
	if ! bobshell_regex_match "$_bobshell_cli_setup__var" '[A-Za-z_][A-Za-z0-9_]*'; then
		bobshell_die "bobshell_cli_setup: malformed $_bobshell_cli_setup__var"
	fi



	# param & flag
	if [ true = "$_bobshell_cli_setup__param" ]; then
		: "${_bobshell_cli_setup__default_unset:=true}"
	fi
	if [ true = "$_bobshell_cli_setup__flag" ]; then
		: "${_bobshell_cli_setup__default_value:=false}"
		: "${_bobshell_cli_setup__default_unset:=false}"
	fi
	if bobshell_isset _bobshell_cli_setup__flag_value; then
		: "${_bobshell_cli_setup__flag:=true}"
	fi
	if [ true = "$_bobshell_cli_setup__param" ] && [ true = "$_bobshell_cli_setup__flag" ]; then
		bobshell_die "bobshell_cli_setup: ambigous param or flag"
	fi


	#
	if [ true = "$_bobshell_cli_setup__default_unset" ] && bobshell_isset _bobshell_cli_setup__default_value; then
		bobshell_die "bobshell_cli_setup: both --default-unset and --default-value not allowed"
	fi


	if [ true = "$_bobshell_cli_setup__param" ]; then
		: "${_bobshell_cli_setup__default_unset:=true}"
	fi
	if [ true = "$_bobshell_cli_setup__flag" ] ; then
		: "${_bobshell_cli_setup__default_unset:=false}"
		: "${_bobshell_cli_setup__flag_value:=true}"	
	fi

	#
	if [ true = "$_bobshell_cli_setup__param" ]; then
		if [ true = "$_bobshell_cli_setup__flag" ] || bobshell_isset _bobshell_cli_setup__flag_value; then
			bobshell_die "bobshell_cli_setup: ambigous --param  and --flag or --flag-value"
		fi
	elif [ false = "$_bobshell_cli_setup__flag" ] && ! bobshell_isset _bobshell_cli_setup__flag_value; then
		bobshell_die "bobshell_cli_setup: if not --param then require --flag --flag-value"
	fi

}
