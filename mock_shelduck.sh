






# todo use real shelduck
shelduck() {
	if [ -f "$1" ]; then
		shelduck_src=$(cat "./$1")
		eval "$shelduck_src"
	else
		printf %s "mock_shelduck: dependency $1 not supported"
		return 1
	fi
}