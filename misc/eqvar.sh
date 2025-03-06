
shelduck import ../base.sh

# fun: bobshell_equals [VAR1 [VAR2]]
# txt: return ok if both arguments are defined and the same
bobshell_eqvar() {
	if bobshell_isset "$1"; then
		if ! bobshell_isset "$2"; then
			return 1
		fi
	else
		if bobshell_isset "$2"; then
			return 1
		else
			return 0
		fi
	fi

	if eval "test \"\$$1\" = \"\$$2\""; then
		return 0
	else
		return 1
	fi

}