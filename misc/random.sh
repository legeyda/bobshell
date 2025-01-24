
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
		if ! bobshell_isset bobshell_random_seed; then
			bobshell_random_seed=$(date +%s)
		fi
		bobshell_random_seed=$(( (bobshell_random_seed*1103515245 + 12345) % 2147483648 ))
		printf %s "$bobshell_random_seed"
	}
fi
