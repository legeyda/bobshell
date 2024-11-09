

# todo use real shelduck
shelduck() {
	if [ -f "$1" ]; then
		. "./$1"
	else
		printf %s "mock_shelduck: dependency $1 not supported"
		return 1
	fi
}