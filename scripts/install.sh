#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ROOT_DIR=$(cd "$SCRIPT_DIR/.." && pwd)

# shellcheck disable=SC1091
source "$ROOT_DIR/bin/shell-progress/spinner.sh"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
if [ "$OS" == "darwin" ]; then
	OS="osx"
fi
ARCH="$(uname -m | tr '[:upper:]' '[:lower:]')"

debug_msg() {
	echo "$@" >&2
}

safelink() {
	DOTFILE="$1"
	CONFIG="$2"

	# Continue if the link already exists
	if [[ -L "$CONFIG" && "$DOTFILE" = "$(readlink "$CONFIG")" ]]; then
		# debug_msg "link $CONFIG -> $DOTFILE is already set up."
		return
	fi

	# Back up any existing configuration.
	if [[ -e "$CONFIG" ]]; then
		local BACKUP
		BACKUP="$CONFIG.dotfiles-backup.$(date '+%Y%m%d-%H%M%S')"
		mv "$CONFIG" "$BACKUP"
		# debug_msg "Backed up $CONFIG to $BACKUP"
	fi

	# Write the link
	mkdir -p "$(dirname "$CONFIG")"
	ln -Fhis "$DOTFILE" "$CONFIG"
}

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
	safelink "$ROOT_DIR/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
	sleep 0.1
	stop_spinner $?
}

gitconfig() {
	start_spinner "  git"
	safelink "$ROOT_DIR/git/.gitconfig" "$HOME/.gitconfig"
	sleep 0.1
	stop_spinner $?
}

tmux() {
	local tmux_path="$ROOT_DIR/tmux"
	start_spinner "  oh-my-tmux"
	test -d "$tmux_path/oh-my-tmux" || git clone https://github.com/gpakosz/.tmux.git "$tmux_path/oh-my-tmux" &>/dev/null
	cd "$tmux_path/oh-my-tmux" && git pull &>/dev/null

	# test -d "$HOME/.config/tmux" || mkdir -p "$HOME/.config/tmux"
	# ln -fs "$TMUX_PATH/oh-my-tmux/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
	# ln -fs "$TMUX_PATH/tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"

	safelink "$tmux_path/oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
	safelink "$tmux_path/tmux.conf.local" "$HOME/.tmux.conf.local"
	stop_spinner $?
}

nvim() {
	start_spinner "  nvim"
	test -d "$HOME/.config/nvim" || git clone https://github.com/ted-vo/nvim.git "$HOME/.config/nvim" &>/dev/null
	cd "$HOME/.config/nvim" && git pull origin main &>/dev/null
	stop_spinner $?
}

toolbox() {
	start_spinner "  toolbox/bin"
	cat >>~/.zshrc <<EOF # toolbox/bin
export PATH="$(
		printf '%s:$%s' "$ROOT_DIR/bin" "PATH"
	)"
EOF
	sleep 0.1
	stop_spinner $?
}

all() {
	zsh
	oh_my_zsh
	alacritty
	gitconfig
	tmux
	nvim
	toolbox
}

main() {
	case $1 in
	zsh)
		zsh
		exit
		;;
	oh_my_zsh)
		oh_my_zsh
		exit
		;;
	alacritty)
		alacritty
		exit
		;;
	gitconfig)
		gitconfig
		exit
		;;
	tmux)
		tmux
		exit
		;;
	nvim)
		nvim
		exit
		;;
	toolbox)
		toolbox
		exit
		;;
	all)
		all
		exit
		;;
	*)
		echo "Not support!"
		exit
		;;
	esac
}

main $@
