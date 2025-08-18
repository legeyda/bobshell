

shelduck import ../result/set.sh
shelduck import ../cli/setup.sh
shelduck import ../cli/parse.sh
shelduck import ../cli/clear.sh

bobshell_cli_setup bobshell_dev_version_cli --flag --var=_bobshell_dev_version__allow_dirty     d allow-dirty
bobshell_cli_setup bobshell_dev_version_cli --flag --var=_bobshell_dev_version__allow_snapshot  s allow-snapshot

# fun: bobshell_dev_version --allow-dirty
bobshell_dev_version() {
	bobshell_cli_parse bobshell_dev_version_cli "$@"
	shift "$bobshell_cli_shift"

	if ! _bobshell_dev_version__status=$(git status --porcelain); then
		unset _bobshell_dev_version__status
		bobshell_result_set false 'not a git repo'
		return
	fi

	if [ "$_bobshell_dev_version__status" ]; then
		if [ true != "$_bobshell_dev_version__allow_dirty" ]; then
			bobshell_result_set false 'repo is dirty, which is not allowed'
			return
		fi
		_bobshell_dev_version__prefix=dirty-
		_bobshell_dev_version__suffix=-SNAPSHOT
	else
		_bobshell_dev_version__prefix=
		_bobshell_dev_version__suffix=
	fi



	if _bobshell_dev_version=$(git describe --exact-match --tags); then
		true
	elif _bobshell_dev_version=$(git branch --show-current); then
		_bobshell_dev_version__suffix=-SNAPSHOT
	else
		bobshell_result_set false 'no git branch'
	fi

	bobshell_result_set true "$_bobshell_dev_version__prefix$_bobshell_dev_version$_bobshell_dev_version__suffix"

	unset _bobshell_dev_version__prefix _bobshell_dev_version__suffix _bobshell_dev_version
	bobshell_cli_clear bobshell_dev_version_cli
}