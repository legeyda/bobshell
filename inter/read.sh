

bobshell_inter_read() {

	_bobshell_inter_read__silent=false
	unset _bobshell_inter_read__prompt
	while bobshell_isset_1 "$@"; do
		case "$1" in
			(-s) _bobshell_inter_read__silent=true; shift ;;
			(-p) _bobshell_inter_read__prompt="$2"; shift 2 ;;
			(*-) bobshell_die "unknown option $1" ;;
			(*) break
		esac
	done

	if ! bobshell_isset_1 "$@"; then
		bobshell_die "bobshell_inter_read: argument expected"
	fi

	if bobshell_isset_2 "$@"; then
		bobshell_die "bobshell_inter_read: max single argument expected"
	fi

	if bobshell_isset _bobshell_inter_read__prompt; then
		printf %s "$_bobshell_inter_read__prompt"
		unset _bobshell_inter_read__prompt
	fi

	if [ true = "$_bobshell_inter_read__silent" ]; then
		# https://github.com/biox/pa/blob/main/pa
		[ -t 0 ] && stty -echo
	fi

	read -r "$1"

	if [ true = "$_bobshell_inter_read__silent" ]; then
		# https://github.com/biox/pa/blob/main/pa
		[ -t 0 ] &&  stty echo
	fi
	unset _bobshell_inter_read__silent

}