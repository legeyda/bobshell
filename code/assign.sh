
shelduck import ../misc/random.sh
shelduck import ../base.sh

# fun: bobshell_code_assign VARNAME VALUE
bobshell_code_assign() {
	if bobshell_isset_2 "$@"; then
		if bobshell_contains "$2" "'"; then
			bobshell_code_assign_random=$(bobshell_random)

			# shellcheck disable=SC2016
			printf '%s=$(cat<<\EOF_%s
	%s
	EOF_%s
	fi
	)' "$1" "$bobshell_code_assign_random" "$2" "$bobshell_code_assign_random"
			unset bobshell_code_assign_random
		else
			printf "%s='%s'" "$1" "$2"
		fi
	else
		printf 'unset %s' "$1"
	fi
}