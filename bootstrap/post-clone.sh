#! /usr/bin/env bash

source "${HOME}/.homesick/helper.sh"

TMUX_VERSION=$(tmux 2>/dev/null -V | sed -En "s/^tmux[^0-9]*([.0-9]+).*/\1/p")
if ! satisfied "3.5" "${TMUX_VERSION}"; then
	if is_mac; then
		# gawk for plugins, utf8proc neeeded on mac
		desired=(autoconf automake pkg-config utf8proc gawk)
		missing=()
		check_brewed "missing" "${desired[@]}"
		declare -p missing
		if [[ "${#missing[@]}" -gt 0 ]]; then
			echo "(brew) installing ${missing[*]}"
			brew install "${missing[@]}"
		fi
	else
		# gawk needed for plugins
		desired=(build-essential autoconf automake pkg-config \
			libevent-dev libncurses5-dev libutf8proc-dev \
			libutf8proc2 byacc gawk)
		missing=()
		check_dpkged "missing" "${desired[@]}"
		if [[ "${#missing[@]}" -gt 0 ]]; then
			echo "(apt) installing ${missing[*]}"
			sudo apt-get -y update
			sudo apt-get -y install "${missing[@]}"
		fi

	fi
	echo "Recompiling tmux"
	mkdir -p "${HOME}/software"
	cd "${HOME}/software" || exit
	git clone https://github.com/tmux/tmux.git tmux_src
	cd "${HOME}/software/tmux_src" || exit
	# optionally use a specific version
	# git checkout 3.3a
	sh autogen.sh
	FLAGS="--enable-utf8proc"
	if is_mac; then
		CPPFLAGS="-I/opt/homebrew/Cellar/utf8proc/2.8.0/include" \
			LDFLAGS="-L/opt/homebrew/Cellar/utf8proc/2.8.0/lib" \
			./configure ${FLAGS} --prefix="${HOME}/software/tmux"
	else
		./configure ${FLAGS} --prefix="${HOME}/software/tmux"
	fi
	make
	make install
fi

echo "Configuring tmux plugins"
mkdir -p "${HOME}/.local/share/tmux/plugins"
cd "${HOME}/.local/share/tmux/plugins" || exit
git clone --depth=1 https://github.com/tmux-plugins/tpm "${HOME}/.local/share/tmux/plugins/tpm"
