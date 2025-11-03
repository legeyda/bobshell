
shelduck import ../assert.sh
shelduck import ./assert.sh
shelduck import ./isset.sh

# fun: bobshell_result_apply [COMMAND [ARGS...]]
bobshell_result_apply() {
	if ! bobshell_result_isset; then
		bobshell_die 'bobshell_result_apply: result is not set'
	fi

	for _bobshell_result_apply__i in $(seq "$bobshell_result_size"); do
		_bobshell_result_apply__item=$(bobshell_getvar "bobshell_result_$_bobshell_result_apply__i")
		set -- "$@" "$_bobshell_result_apply__item"
	done
	unset _bobshell_result_apply__i _bobshell_result_apply__item

	"$@"
}
