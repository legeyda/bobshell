
shelduck import ../base.sh
shelduck import ../app.sh
shelduck import ../url.sh




bobshell_python() {
	# https://www.anaconda.com/docs/getting-started/miniconda/main#quick-command-line-install
	# https://www.anaconda.com/docs/getting-started/miniconda/install#quickstart-install-instructions
	bobshell_python_venv_ensure

	"$bobshell_python_venv/bin/python" "$@"
}

bobshell_python_venv_ensure() {
	bobshell_python_home_ensure

	: "${bobshell_python_name:=default}"

	if bobshell_isset _bobshell_python_name_stash; then
		if [ "$_bobshell_python_name_stash" = "$bobshell_python_name" ]; then
			return
		fi
	fi
	_bobshell_python_name_stash=$bobshell_python_name
	bobshell_python_venv="$HOME/.cache/$bobshell_app_name/python/venv/$bobshell_python_name"
	if [ -f "$bobshell_python_venv/bin/activate" ]; then
		return
	fi
	mkdir -p "$bobshell_python_venv"
	"$bobshell_python_home/bin/python" -m venv "$bobshell_python_venv"
}

bobshell_python_home_ensure() {
	if bobshell_isset _bobshell_python_app_name_stash; then
		if [ "$_bobshell_python_app_name_stash" = "$bobshell_app_name"  ]; then
			return
		fi
	fi

	_bobshell_python_app_name_stash=$bobshell_app_name
	bobshell_python_home="$HOME/.cache/$bobshell_app_name/python/miniconda"
	
	
	if [ -f "$bobshell_python_home/bin/activate" ]; then
		return
	fi

	mkdir -p "$bobshell_python_home"

	bobshell_fetch_url https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > "$bobshell_python_home/miniconda-install.sh"
	sh "$bobshell_python_home/miniconda-install.sh" -b -u -p "$bobshell_python_home" > /dev/null
	rm -f "$bobshell_python_home/miniconda-install.sh"
}
