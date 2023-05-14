#! /bin/bash

TMUX_VERSION=$(tmux 2>/dev/null -V | sed -En "s/^tmux[^0-9]*([.0-9]+).*/\1/p")
if [[ -z "${TMUX_VERSION}" || "$(echo "${TMUX_VERSION} < 3.5" | bc)" -eq 1 ]]; then
	echo "Installing build requirements for tmux"
	sudo apt-get -y update
	sudo apt-get -y install build-essential autoconf automake pkg-config \
		libevent-dev libncurses5-dev byacc
	echo "Recompiling tmux"
	mkdir -p "${HOME}/software"
	cd "${HOME}/software" || exit
	git clone https://github.com/tmux/tmux.git tmux_src
	cd "${HOME}/software/tmux_src" || exit
	# optionally use a specific version
	# git checkout 3.3a
	sh autogen.sh
	./configure --prefix="${HOME}/software/tmux"
	make
	make install
fi

echo "Configuring tmux plugins"
mkdir -p "${HOME}/.local/share/tmux/plugins"
cd "${HOME}/.local/share/tmux/plugins" || exit
git clone --depth=1 https://github.com/tmux-plugins/tpm "${HOME}/.local/share/tmux/plugins/tpm"
