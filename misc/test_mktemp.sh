



shelduck import ../assert.sh
shelduck import ./mktemp.sh
shelduck import ../result/check.sh


mkcd() {
	mkdir -p "$1"
	cd "$1"
}


test_mkdir() {
	bobshell_mktemp
	assert_ok bobshell_result_check _dir
	assert_file_exists "$_dir"
	
}