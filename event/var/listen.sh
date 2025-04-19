

shelduck import ../../base.sh
shelduck import ../listen.sh

bobshell_event_var_listen() {

	_bobshell_event_var_listen__moment=after
	while bobshell_isset_1 "$@"; do
		case "$1" in
			(-m|--moment) 
				_bobshell_event_var_listen__moment="$2"
				shift 2
				;;
			(-*)
				bobshell_die "bobshell_event_var_listen: unsupported option $1"
				;;
			(*) break
		esac
	done

	_bobshell_event_var_listen__var="$1"
	shift
	if [ before = "$_bobshell_event_var_listen__moment" ]; then
		bobshell_event_listen "_bobshell_event_var_${_bobshell_event_var_listen__var}_before_event" "$@"
	elif [ after = "$_bobshell_event_var_listen__moment" ]; then
		bobshell_event_listen "_bobshell_event_var_${_bobshell_event_var_listen__var}_after_event" "$@"
 	else
		bobshell_die 'unsupported moment value'
	fi
	
	unset _bobshell_event_var_listen__moment _bobshell_event_var_listen__var
}
