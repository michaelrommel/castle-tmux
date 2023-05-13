#! /bin/bash

echo "Configuring tmux plugins"
mkdir -p "${HOME}/.local/share/tmux/plugins"
cd "${HOME}/.local/share/tmux/plugins" || exit
git clone --depth=1 https://github.com/tmux-plugins/tpm "${HOME}/.local/share/tmux/plugins/tpm"
for p in tmux-network-bandwidth tmux-gruvbox tmux-plugin-cpu; do
	ln -s ../../../../.dotfiles/.local/share/tmux/plugins/$p .
done
"${HOME}/.local/share/tmux/plugins/tpm/bin/install_plugins"

