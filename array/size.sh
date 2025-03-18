
shelduck import ../base.sh
shelduck import ./assert_isset.sh
shelduck import ../resource/copy.sh

# fun: bobshell_array_size myarr
#      bobshell_result_assert _get_my_size
bobshell_array_size() {
	bobshell_array_assert_isset "$1"
	bobshell_result_size=2
	bobshell_result_1=true
	bobshell_resource_copy_var_to_var "${1}_size" bobshell_result_2
}