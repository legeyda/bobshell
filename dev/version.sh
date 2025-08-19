

shelduck import ../result/set.sh
shelduck import ../cli/setup.sh
shelduck import ../cli/parse.sh
shelduck import ../cli/clear.sh

bobshell_cli_setup bobshell_dev_version_cli --flag --var=_bobshell_dev_version__allow_snapshot  s allow-snapshot

# fun: bobshell_dev_version --allow-dirty
bobshell_dev_version() {
	bobshell_cli_parse bobshell_dev_version_cli "$@"
	shift "$bobshell_cli_shift"

	if ! _bobshell_dev_version__status=$(git status --porcelain 2> /dev/null); then
		unset _bobshell_dev_version__status
		bobshell_dev_version_result false 'not a git repo'
		return
	fi

	if [ "$_bobshell_dev_version__status" ]; then
		if [ true != "$_bobshell_dev_version__allow_snapshot" ]; then
			bobshell_dev_version_result false 'repo is dirty, which is not allowed (or use --allow-snapshot)'
			return
		fi
		_bobshell_dev_version__snapshot=-SNAPSHOT
	else
		_bobshell_dev_version__snapshot=
	fi
	unset _bobshell_dev_version__status


	if _bobshell_dev_version=$(git describe --exact-match --tags 2> /dev/null); then
		bobshell_remove_prefix "$_bobshell_dev_version" v _bobshell_dev_version || true
	elif _bobshell_dev_version=$(git branch --show-current 2> /dev/null); then
		if [ true != "$_bobshell_dev_version__allow_snapshot" ]; then
			bobshell_dev_version_result false 'no tag, only branch snapshot, which is not allowed (or use --allow-snapshot)'
			return
		fi
		bobshell_remove_prefix "$_bobshell_dev_version" release/ _bobshell_dev_version || true
		_bobshell_dev_version__snapshot=-SNAPSHOT
	else
		bobshell_dev_version_result false 'no git branch'
		return
	fi
	_bobshell_dev_version=$(printf %s "$_bobshell_dev_version" | tr / -)
	bobshell_dev_version_result true "$_bobshell_dev_version$_bobshell_dev_version__snapshot"
}

bobshell_dev_version_result() {
	bobshell_cli_clear bobshell_dev_version_cli 
	unset _bobshell_dev_version__status _bobshell_dev_version__snapshot
	bobshell_result_set "$@"
}