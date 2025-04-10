
shelduck import ../base.sh
shelduck import ../app.sh
shelduck import ../url.sh




bobshell_python() {
	# https://www.anaconda.com/docs/getting-started/miniconda/main#quick-command-line-install
	# https://www.anaconda.com/docs/getting-started/miniconda/install#quickstart-install-instructions

	_bobshell_python__installation="$HOME/.cache/$bobshell_app_name/python/miniconda"
	if [ ! -f "$_bobshell_python__installation/bin/activate" ]; then
		mkdir -p "$_bobshell_python__installation"
		_bobshell_python__conda_installer=$(mktemp -d)

		bobshell_fetch_url https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > "$_bobshell_python__conda_installer/miniconda-install.sh"
		#chmod +x "$_bobshell_python__conda_installer"
		sh "$_bobshell_python__conda_installer/miniconda-install.sh" -b -u -p "$_bobshell_python__installation" > /dev/null
		rm -rf "$_bobshell_python__conda_installer"
		unset _bobshell_python__conda_installer
	fi

	_bobshell_python__venv="$HOME/.cache/$bobshell_app_name/python/venv/${bobshell_python_venv:-default}"
	if [ ! -f "$_bobshell_python__venv/bin/activate" ]; then
		mkdir -p "$_bobshell_python__venv"
		"$_bobshell_python__installation/bin/python" -m venv "$_bobshell_python__venv"
	fi

	"$_bobshell_python__venv/bin/python" "$@"
}