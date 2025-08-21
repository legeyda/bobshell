
shelduck import ../map/put.sh

# fun: bobshell_cache_put KEY VALUE
bobshell_cache_put() {
	bobshell_map_put bobshell_cache_data "$@"
}