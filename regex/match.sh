


bobshell_regex_match() {
	case "$2" in
		(^*$) printf '%s\n' "$1" | grep -q -- "$2" ;;
		(^*)  printf '%s\n' "$1" | grep -q -- "$2\$" ;;
		 (*$) printf '%s\n' "$1" | grep -q -- "^$2" ;;
		 (*)  printf '%s\n' "$1" | grep -q -- "^$2\$" ;;
	esac
}
