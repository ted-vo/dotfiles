# Mechkey

## QMK

### Prerequisites

```bash
sudo pacman --needed --noconfirm -S git python-pip libffi
```

### Installation

QMK

```bash
# option 1
python3 -m pip install --user qmk

# option 2
sudo pacman -S qmk

# option 3
yay -S qmk-git
```

SETUP

```bash
# setup
qmk setup

# checkhealth
qmk doctor
```

### Compile & flash

```bash
# move source keymaps


# compile
qmk compile -kb sofle -km tedvo

# flash
qmk flash -kb sofle -km tedvo
```

### Troubleshooting

```bash
# error with arv-gcc > 11
qmk flash -kb sofle -km tedvo -e AVR_CFLAGS="-Wno-array-bounds"
```

Can not connect keyboard in Arch

```
# Create the following udev rule:
# /etc/udev/rules.d/99-via.rules
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
```
