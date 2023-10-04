# Hyprland

## Troubleshooting

- audio missing

```bash
# check soundcard loaded
cat /proc/asound/cards

# missing sof-firmware
sudo pacman -S sof-firmware

# reboot
reboot
```
