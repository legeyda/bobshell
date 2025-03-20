
shelduck import ../array/set.sh

# fun: bobshell_result_set true
bobshell_result_set() {
	if   [ 0 = "$#" ]; then
		bobshell_result_size=0
	elif [ 1 = "$#" ]; then
		bobshell_result_size=1
		bobshell_result_1="$1"
	elif [ 2 = "$#" ]; then
		bobshell_result_size=2
		bobshell_result_1="$1"
		bobshell_result_2="$2"
	elif [ 3 = "$#" ]; then
		bobshell_result_size=3
		bobshell_result_1="$1"
		bobshell_result_2="$2"
		bobshell_result_3="$3"
	elif [ 4 = "$#" ]; then
		bobshell_result_size=4
		bobshell_result_1="$1"
		bobshell_result_2="$2"
		bobshell_result_3="$3"
		bobshell_result_4="$4"
	elif [ 5 = "$#" ]; then
		bobshell_result_size=5
		bobshell_result_1="$1"
		bobshell_result_2="$2"
		bobshell_result_3="$3"
		bobshell_result_4="$4"
		bobshell_result_5="$5"
	elif [ 6 = "$#" ]; then
		bobshell_result_size=6
		bobshell_result_1="$1"
		bobshell_result_2="$2"
		bobshell_result_3="$3"
		bobshell_result_4="$4"
		bobshell_result_5="$5"
		bobshell_result_6="$6"
	elif [ 7 = "$#" ]; then
		bobshell_result_size=7
		bobshell_result_1="$1"
		bobshell_result_2="$2"
		bobshell_result_3="$3"
		bobshell_result_4="$4"
		bobshell_result_5="$5"
		bobshell_result_6="$6"
		bobshell_result_7="$7"
	elif [ 8 = "$#" ]; then
		bobshell_result_size=8
		bobshell_result_1="$1"
		bobshell_result_2="$2"
		bobshell_result_3="$3"
		bobshell_result_4="$4"
		bobshell_result_5="$5"
		bobshell_result_6="$6"
		bobshell_result_7="$7"
		bobshell_result_8="$8"
	elif [ 9 = "$#" ]; then
		bobshell_result_size=9
		bobshell_result_1="$1"
		bobshell_result_2="$2"
		bobshell_result_3="$3"
		bobshell_result_4="$4"
		bobshell_result_5="$5"
		bobshell_result_6="$6"
		bobshell_result_7="$7"
		bobshell_result_8="$8"
		bobshell_result_9="$9"
	else
		bobshell_array_set bobshell_result "$@"
	fi
}
