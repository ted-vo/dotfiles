#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ROOT_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
ALACRITTY_PATH="$ROOT_DIR/alacritty"
LOADING_PATH="$ROOT_DIR/shell-progress"
TOOLBOX_BIN_PATH="$ROOT_DIR/bin"
TMUX_PATH="$ROOT_DIR/tmux"

# shellcheck disable=SC1091
source "$LOADING_PATH/spinner.sh"

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
	ln -Fs "$ALACRITTY_PATH/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
	sleep 0.1
	stop_spinner $?
}

tmux() {
	start_spinner "  oh-my-tmux"
	test -d "oh-my-tmux" || git clone https://github.com/gpakosz/.tmux.git "$TMUX_PATH/oh-my-tmux" &>/dev/null
	cd "$TMUX_PATH/oh-my-tmux" && git pull &>/dev/null

	# test -d "$HOME/.config/tmux" || mkdir -p "$HOME/.config/tmux"
	# ln -fs "$TMUX_PATH/oh-my-tmux/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
	# ln -fs "$TMUX_PATH/tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"

	ln -Fs "$TMUX_PATH/oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
	ln -Fs "$TMUX_PATH/tmux.conf.local" "$HOME/.tmux.conf.local"
	stop_spinner $?
}

toolbox() {
	start_spinner "  toolbox/bin"
	cat >>~/.zshrc <<EOF

# toolbox/bin
export PATH="$(printf '%s:$%s' "$TOOLBOX_BIN_PATH" "PATH")"
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
