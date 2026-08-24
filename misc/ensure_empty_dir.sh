shelduck import ../result/set.sh

bobshell_ensure_empty_dir() {
	while [ "$#" -gt 0 ]; do
		if [ -e "$1" ]; then
			if ! [ -d "$1" ]; then
				bobshell_result_set false "$1 is not a directory"
				break
			fi
			find "$1" -mindepth 1 -maxdepth 1 -exec rm -rf {} + # todo echo
		else
			mkdir -p "$1"
		fi
		shift
	done
	bobshell_result_set true
}