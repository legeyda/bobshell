



shelduck import ../base.sh
shelduck import ../result/set.sh


if [ -r /dev/urandom ]; then
	bobshell_random_int() {
		# shellcheck disable=SC2046 # to get rid of trailing spaces
		_bobshell_random_int=$(printf %s $(od -An -N4 -tu4 /dev/urandom))
		bobshell_result_set true "$_bobshell_random_int"
		unset _bobshell_random_int
	}
elif bobshell_command_available openssl; then
	bobshell_random_int() {
		_bobshell_random_int="$(openssl rand 4 | od -An -N4 -tu4)"
		bobshell_result_set true "$_bobshell_random_int"
		unset _bobshell_random_int
	}
elif bobshell_isset RANDOM && [ "$RANDOM" != "$RANDOM" ]; then
	bobshell_random_int() {
		_bobshell_random_int="1$RANDOM$RANDOM$RANDOM"
		bobshell_result_set true "$_bobshell_random_int"
		unset _bobshell_random_int
	}
else
	# txt: analogouys to glibc LCG (https://en.wikipedia.org/wiki/Linear_congruential_generator)()
	bobshell_random_int() {
		: "${_bobshell_random_int:=0}"
		_bobshell_random_int=$(( ( _bobshell_random_int * 1103515245 + $(date +%s)) % 2147483648 ))
		bobshell_result_set true "$_bobshell_random_int"
	}
fi
