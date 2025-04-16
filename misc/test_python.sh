

shelduck import ../assert.sh
shelduck import ./python.sh
shelduck import ../redirect/output.sh



# fun: docker_run SHELDUCKSCRIPT [ARGS...]
docker_run() {
	_docker_run__script=$(shelduck resolve "$1")
	shift
	_docker_run__args=$(bobshell_quote "$@")
	docker run --name bobshell_test --rm -i --log-driver=none -a stdin -a stdout -a stderr ubuntu sh -euxc "set -- $_docker_run__args
$_docker_run__script"
	unset _docker_run__script _docker_run__args
}



test_python() {
	_test_python__import="shelduck import file://$(pwd)/misc/python.sh"

	unset x
	bobshell_redirect_output var:x docker_run "val:
set -eux
apt-get --yes update > /dev/null
apt-get --yes install curl > /dev/null
$_test_python__import
bobshell_python -c 'print(\"hello\")'
"
#

	assert_equals "hello$bobshell_newline" "$x"
}

local_debug_python() {
	unset x
	bobshell_redirect_output var:x bobshell_python -c 'print("hello")'
	assert_equals "hello$bobshell_newline" "$x"
}
