



shelduck import -a die base.sh
shelduck import util.sh
shelduck import assert.sh


test_list_var_names() {
	export X='str1'"'"'
str2
str3'


	bobshell_list_var_names | sort
	
	die debug
}