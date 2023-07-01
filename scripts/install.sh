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
	test -d "$HOME/.config" || mkdir -p "$HOME/.config"
	ln -Fs "$ALACRITTY_PATH" "$HOME/.config/alacritty"
	sleep 0.1
	stop_spinner $?
}

tmux() {
	start_spinner "  tmux"
	test -d "$HOME/.config" || mkdir -p "$HOME/.config/tmux"
	ln -Fs "$TMUX_PATH" "$HOME/.config/tmux"
	sleep 0.1
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
