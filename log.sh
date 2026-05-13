







# bobshell_log_level INFO
bobshell_log_level() {
    case "$1" in
        (ALL): 
        (TRACE): 5000
        DEBUG: 10000
        INFO: 20000
        WARN: 30000
        ERROR: 40000
        FATAL: 50000 (Not in core SLF4J API)
        OFF: Integer.MAX_VALUE



        debug|info|warn|error)
            _bobshell_log_level="$1"
            ;;
        *)
            printf "Invalid log level: %s\n" "$1" >&2
            return 1
            ;;
    esac

    _bobshell_log_level=
    local level="$1"
    shift
    printf "[%s] %s\n" "$level" "$*"
}

bobshell_log() {
    _bobshell_log_level="$1"
    shift
    if 

}

bobshell_log_info() {
    bobshell_log_level INFO "$@"
}

bobshell_log DEBUG "This is a debug message"
bobshell_log INFO "This is an info message"
bobshell_log ERROR "This is an error message"
bobshell_log WARN "This is a warning message"
bobshell_log FATAL "This is a fatal message"