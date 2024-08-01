# Hyprland

<div align="center"><img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footers/gray0_ctp_on_line.png"></div>

<div align="center">
  <p></p>
  
  - 📀 **Distro** - [Arch](https://archlinux.org/) 
  - 🧩 **Wayland compositor** - [Hyprland](https://hyprland.org/) 
  - 🪄 **Bar** - [Waybar](https://github.com/Alexays/Waybar) 
  - 🗂 **File Manager** - [Thunar](https://gitlab.xfce.org/xfce/thunar) 
  - 📟 **Terminal** - [Alacrity](https://github.com/alacritty/alacritty) 
  - 🐚 **Shell** - [Zsh](https://zsh.sourceforge.io/) 
  - 🎉 **Notifications** - [Mako](https://github.com/emersion/mako) 
  - 🎰 **Launcher** - [Rofi](https://github.com/lbonn/rofi) 
  - 🏙 **Wallpaper** - [Swaybg](https://github.com/swaywm/swaybg) 
  - 🖥 **Screen locker** - [Swaylock](https://github.com/swaywm/swaylock) 
</div>

## Manual Installation

```bash
yay -S hyprland kitty waybar \
    swaybg swaylock-effects wofi wlogout mako thunar tumbler \
    ttf-jetbrains-mono-nerd noto-fonts-emoji \
    polkit-gnome python-requests starship \
    swappy grim slurp pamixer brightnessctl gvfs \
    bluez bluez-utils lxappearance xfce4-settings \
    dracula-gtk-theme dracula-icons-git xdg-desktop-portal-hyprland
```

## Troubleshooting

<details>
    <summary>Audio missing</summary>

```bash
# check soundcard loaded
cat /proc/asound/cards

# missing sof-firmware
sudo pacman -S sof-firmware

# reboot
reboot
```

</details>
