#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
HOME_CONFIG_PATH="$HOME"/.config
ALACRITTY_CONFIG_PATH="$HOME_CONFIG_PATH"/alacritty

test -d "$HOME_CONFIG_PATH" || (echo "Create ~/.config/alacritty" && mkdir -p "$HOME_CONFIG/alacritty")

echo -ne "Create symbol link ==> "
ln -Fs "$SCRIPT_DIR"/alacritty.yml "$ALACRITTY_CONFIG_PATH"/alacritty.yml

echo " ✅ OK"
