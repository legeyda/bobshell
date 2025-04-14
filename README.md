This a libarary of reusable shell code for [shelduck](https://github.com/legeyda/shelduck) tool.




Do not do this:

	foo() {
		printf %s xyz
	}
	foo=$(bar)

Do this:

	foo() {
		bobshell_result_set xyz
	}
	bobshell_result_read foo