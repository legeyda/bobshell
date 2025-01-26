
shelduck import ../base.sh

if [ -r /dev/random ]; then
	bobshell_random() {
		# shellcheck disable=SC2046 # to get rid of trailing spaces
		printf %s $(od -An -N4 -tu4 /dev/urandom)
	}
elif bobshell_isset RANDOM; then
	bobshell_random() {
		printf 1%s%s%s $RANDOM $RANDOM $RANDOM
	}
else
	# txt: analogouys to glibc LCG (https://en.wikipedia.org/wiki/Linear_congruential_generator)()
	bobshell_random() {
		if ! bobshell_isset_1 "$@"; then
			set -- "$(date +%s)"
		fi
		: "${bobshell_random:=0}"
		bobshell_random=$(( ( bobshell_random * 1103515245 + 12345 + $1) % 2147483648 ))
		printf %s "$bobshell_random"
	}
fi
