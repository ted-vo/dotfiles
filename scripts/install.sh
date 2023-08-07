#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ROOT_DIR=$(cd "$SCRIPT_DIR/.." && pwd)

# shellcheck disable=SC1091
source "$ROOT_DIR/bin/shell-progress/spinner.sh"

zsh() {
	start_spinner "  zsh"
	sleep 0.1
	stop_spinner $?
}

oh_my_zsh() {
	start_spinner "  oh_my_zsh"
	sleep 0.1
	stop_spinner $?
}

alacritty() {
	start_spinner "  alacritty"
	test -d "$HOME/.config/alacritty" || mkdir -p "$HOME/.config/alacritty"
	ln -Fs "$ROOT_DIR/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
	sleep 0.1
	stop_spinner $?
}

tmux() {
	start_spinner "  oh-my-tmux"
	test -d "oh-my-tmux" || git clone https://github.com/gpakosz/.tmux.git "$TMUX_PATH/oh-my-tmux" &>/dev/null
	cd "$ROOT_DIR/tmux/oh-my-tmux" && git pull &>/dev/null

	# test -d "$HOME/.config/tmux" || mkdir -p "$HOME/.config/tmux"
	# ln -fs "$TMUX_PATH/oh-my-tmux/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
	# ln -fs "$TMUX_PATH/tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"

	ln -Fs "$ROOT_DIR/tmux/oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
	ln -Fs "$ROOT_DIR/tmux/tmux.conf.local" "$HOME/.tmux.conf.local"
	stop_spinner $?
}

toolbox() {
	start_spinner "  toolbox/bin"
	cat >>~/.zshrc <<EOF

# toolbox/bin
export PATH="$(printf '%s:$%s' "$ROOT_DIR/bin" "PATH")"
EOF
	sleep 0.1
	stop_spinner $?
}

main() {
	zsh
	oh_my_zsh
	alacritty
	tmux
	toolbox
}

main
