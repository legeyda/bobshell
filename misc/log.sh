

bobshell_log_init() {

	unset _bobshell_log_level
	if [ -n "${BOBSHELL_LOG_LEVEL:-}" ]; then
		BOBSHELL_LOG_LEVEL=$(printf %s "$BOBSHELL_LOG_LEVEL" | awk 'BEGIN { getline; print toupper($0) }')

		bobshell_log_parse_syslog 0 EMERG        # The system is unusable
		bobshell_log_parse_syslog 1 ALERT        # Action must be taken immediately
		bobshell_log_parse_syslog 2 CRIT         # Critical conditions
		bobshell_log_parse_syslog 3 ERR ERROR    # Error conditions
		bobshell_log_parse_syslog 4 WARN WARNING # Warning conditions
		bobshell_log_parse_syslog 5 NOTICE       # Normal, but significant, condition
		bobshell_log_parse_syslog 6 INF INFO     # Informational messages
		bobshell_log_parse_syslog 7 DEBUG        # Debug-level messages
		bobshell_log_parse_syslog 8 TRACE        # Trace level message (optional non standard extension)
	fi

	if [ -z "${_bobshell_log_level:-}" ]; then
		case "${DEBUG:-0}" in
			(true|1) _bobshell_log_level=5 ;;
			(2)      _bobshell_log_level=6 ;;
			(3)      _bobshell_log_level=7 ;;
			(*)      _bobshell_log_level=3 ;;
		esac
	fi

	if   [ "$_bobshell_log_level" -ge 7 ]; then
		set -x +v
	elif [ "$_bobshell_log_level" -ge 6 ]; then
		set -v +x
	else
		set +vx
	fi

	bobshell_log_def 0 emerg
	bobshell_log_def 1 alert
	bobshell_log_def 2 crit
	bobshell_log_def 3 error
	bobshell_log_def 4 warn
	bobshell_log_def 5 notice
	bobshell_log_def 6 info
	bobshell_log_def 7 debug
	bobshell_log_def 8 trace

	bobshell_log_trace "bobshell_log_init: done, log level is $_bobshell_log_level"
}

bobshell_log_parse_syslog() {
	local code="$1"
	while [ $# -gt 0 ]; do
		if [ "$BOBSHELL_LOG_LEVEL" = "$1" ]; then
			_bobshell_log_level="$code"
		fi
		shift
	done
}

bobshell_log_def() {
	local script=
	if [ "${_bobshell_log_level:-3}" -ge "$1" ]; then
		script='printf "%s: %s\n" '"$2"' "$*" >&2'
	else
		script=:
	fi
	eval 'bobshell_log_'"$2"'() {
'"$script"'
}'
}

bobshell_log_init
