

. ./mock_shelduck.sh
shelduck base.sh
shelduck assert.sh





main() {
	for func in $(bobshell_list_functions | grep --extended-regexp '^test_' || true); do
		echo "FUNCTION: $func"
	done
}


shelduck ./entry_point.sh