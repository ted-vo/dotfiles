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

# Regular Colors
Black='\e[1;30m'  # Black
Red='\e[1;31m'    # Red
Green='\e[1;32m'  # Green
Yellow='\e[1;33m' # Yellow
Blue='\e[1;34m'   # Blue
Purple='\e[1;35m' # Purple
Cyan='\e[1;36m'   # Cyan
White='\e[1;37m'  # White
NC='\e[0m'        # No Color

# set some colors
INSTLOG="install.log"
CNT="[${Cyan}NOTE${NC}]"
COK="[${Green}OK${NC}]"
CER="[${Red}ERROR${NC}]"
CAT="[${White}ATTENTION${NC}]"
CWR="[${Purple}WARNING${NC}]"
CAC="[${Yellow}ACTION${NC}]"

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
	ln -Fis "$DOTFILE" "$CONFIG"
}

zsh() {
	start_spinner "  zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &>$INSTLOG
	sleep 0.1
	stop_spinner $?
}

oh_my_zsh() {
	start_spinner "  oh_my_zsh"
	sleep 0.1
	stop_spinner $?
}

alacritty() {
	# local requires=(cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python)
	echo -e "$CNT alacritty"

	if [[ $OS == 'linux' ]] && ! which alacritty &>/dev/null; then
		echo -e "$CAT - Alacritty not found"
		read -rep $'[\e[1;33mACTION\e[0m] Would you like to install Alacritty? (y|n)' ALACRITTY
		test $ALACRITTY != 'y' && exit

		git clone https://github.com/alacritty/alacritty.git &>>$INSTLOG
		cd alacritty

		# libraries required
		sudo pacman -Sy cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python &>$INSTLOG

		# check terminfo
		test infocmp alacritty &>/dev/null || sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

		# use artifact
		sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
		sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
		sudo desktop-file-install extra/linux/Alacritty.desktop
		sudo update-desktop-database
	else
		echo -e "\e[1A\e[K$COK - $1 was installed."
	fi

	test -d "$HOME/.config/alacritty" || mkdir -p "$HOME/.config/alacritty"
	safelink "$ROOT_DIR/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
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
		echo -e "$CER Not support!"
		exit
		;;
	esac
}

main $@
