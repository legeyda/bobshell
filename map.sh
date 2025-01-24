
shelduck import base.sh
shelduck import misc/random.sh

# fun: bobshell_map_put MAPNAME KEY VALUE
bobshell_map_put() {
	
	if bobshell_contains "$2" "'"; then
		bobshell_map_put_random=$(bobshell_random)
		bobshell_map_put_script="bobshell_map_get_candidate=\$(cat<<EOF$bobshell_map_put_random
$2
EOF$bobshell_map_put_random
fi
)"
	else
		bobshell_map_put_script="bobshell_map_get_candidate='$2'"
	fi

	bobshell_map_put_random=$(bobshell_random)
	bobshell_map_put_script="$bobshell_map_put_script
if [ \"\$2\" = \"\$bobshell_map_get_candidate\" ]; then
	cat<<EOF$bobshell_map_put_random
$3
EOF$bobshell_map_put_random
	return
fi
"

	bobshell_map_put_data=$(bobshell_getvar "${1}_data" '')
	bobshell_map_put_data="$bobshell_map_put_script

$bobshell_map_put_data"
	bobshell_putvar "${1}_data" "$bobshell_map_put_data"

	unset bobshell_map_put_random bobshell_map_put_script bobshell_map_put_data
}

# fun: bobshell_map_get MAPNAME KEY [DEFAULTVALUE]
bobshell_map_get() {
	if bobshell_isset "${1}_data"; then
		bobshell_map_get_data=$(bobshell_getvar "${1}_data")
		shift
		set -- "$bobshell_map_get_data" "$@"
		unset bobshell_map_get_data
		eval "$1"
	fi
	if bobshell_isset_3 "$@"; then
		printf %s "$3"
		return
	fi
	return 1
}
