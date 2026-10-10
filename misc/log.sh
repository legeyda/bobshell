

bobshell_log_init() {
	case "${BOBSHELL_LOG_LEVEL:-}" in
		(0|EMERG|emerg)               bobshell_log_level 0 ;; # The system is unusable
		(1|ALERT|alert)               bobshell_log_level 1 ;; # Action must be taken immediately
		(2|CRIT|crit)                 bobshell_log_level 2 ;; # Critical conditions
		(3|ERR|err|ERROR|error)       bobshell_log_level 3 ;; # Error conditions
		(4|WARN|warn|WARNING|warning) bobshell_log_level 4 ;; # Warning conditions
		(5|NOTICE|notice)             bobshell_log_level 5 ;; # Normal, but significant, condition
		(6|INF|inf|INFO|info)         bobshell_log_level 6 ;; # Informational messages
		(7|DEBUG|debug)               bobshell_log_level 7 ;; # Debug-level messages
		(8|TRACE|trace)               bobshell_log_level 8 ;; # Trace level message (optional non standard extension)
		(*)
			case "${DEBUG:-0}" in
				(true|1) bobshell_log_level 5 ;;
				(2)      bobshell_log_level 6 ;;
				(3)      bobshell_log_level 7 ;;
				(*)      bobshell_log_level 3 ;;
			esac
		;;
	esac
}

bobshell_log_level() {
	bobshell_log_level="${1:-}"
	if [ -z "$bobshell_log_level" ] || ! [ "$bobshell_log_level" -ge 0 ] || ! [ "$bobshell_log_level" -le 8 ]; then
		bobshell_log_level=3
	fi

	if   [ "$bobshell_log_level" -ge 7 ]; then
		set -x +v
	elif [ "$bobshell_log_level" -ge 6 ]; then
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

	bobshell_log_trace "bobshell_log_level: $bobshell_log_level"
}


bobshell_log_def() {
	if [ "$bobshell_log_level" -ge "$1" ]; then
		eval 'bobshell_log_'"$2"'() {
		printf "%s: %s\n" '"$2"' "$*" >&2
}'
	else
		eval 'bobshell_log_'"$2"'() {
	:
}'
	fi
}

bobshell_log_init
