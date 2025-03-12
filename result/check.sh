
# txt: bobshell_result_true
#      bobshell_result_printf %s 'hello'
#      if bobshell_result_check; then
#		   bobshell_result_get stdout:
#      done
bobshell_result_check() {
	case "$bobshell_result" in
		(true)  return 0 ;;
		(false) return 1 ;;
		(*) bobshell_die "bobshell_result_check: error parsing result as boolean"
	esac
}
