


shelduck import ../base.sh
shelduck import ../result/set.sh
shelduck import ../result/check.sh
shelduck import ../map/get.sh
shelduck import ../map/put.sh

shelduck import ../cli/param.sh
shelduck import ../cli/parse.sh

bobshell_cli_param   bobshell_cache_get_cli _bobshell_cache_get__ttl t ttl

# fun: bobshell_cache_get KEY LOADERCMD [ARGS ...]
bobshell_cache_get() {
	bobshell_cli_parse bobshell_cache_get_cli "$@"
	shift "$bobshell_cli_shift"

	_bobshell_cache_get__key="$1"
	shift

	bobshell_map_get bobshell_cache_data "$_bobshell_cache_get__key"
	if bobshell_result_check _bobshell_cache_get__value; then
		bobshell_map_get bobshell_cache_deadline "$_bobshell_cache_get__key"
		if ! bobshell_result_check _bobshell_cache_get__deadline || [ "$(date +%s)" -lt "$_bobshell_cache_get__deadline" ]; then
			bobshell_result_set "$_bobshell_cache_get__value"
			unset _bobshell_cache_get__key _bobshell_cache_get__value _bobshell_cache_get__deadline
			return
		fi
	fi



	"$@"
	bobshell_result_read _bobshell_cache_get__value
	bobshell_map_put bobshell_cache_data   "$_bobshell_cache_get__key" "$_bobshell_cache_get__value"


	if bobshell_isset _bobshell_cache_get__ttl; then
		_bobshell_cache_get__deadline=$(date +%s)
		_bobshell_cache_get__deadline=$(( _bobshell_cache_get__deadline + _bobshell_cache_get__ttl ))
		unset _bobshell_cache_get__ttl
		bobshell_map_put bobshell_cache_deadline "$_bobshell_cache_get__key" "$_bobshell_cache_get__deadline"
	fi
	unset _bobshell_cache_get__deadline _bobshell_cache_get__key

	bobshell_result_set "$_bobshell_cache_get__value"
	unset _bobshell_cache_get__value
}