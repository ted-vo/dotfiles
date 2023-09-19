#!/usr/bin/env bash
# Copyright (c) 2023 tedvo. All Rights Reserved.
# This script install Jekyll on ArchLinux

# requirements
echo "Require Ruby"
if ! which ruby &>2; then
	echo -e "Not installed"
	sudo pacman -S ruby base-devel
else
	echo -e "Installed"
fi

echo "Installing Jekyll"
gem install jekyll bundler
