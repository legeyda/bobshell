This a libarary of reusable shell code for [shelduck](https://github.com/legeyda/shelduck) tool.




Do not do this:

	foo() {
		printf %s xyz
	}
	foo=$(bar)

Do this instead:

	foo() {
		bobshell_result_set xyz
	}
	bobshell_result_read foo

There are two problems. First, method invocation inside `$()` cannot have side effects.
Second, `$()` stripes new lines at the end of str.