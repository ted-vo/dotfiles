#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
TOOLBOX_BIN_PATH="$(cd "$SCRIPT_DIR/.." && pwd)/bin"

echo "=== Add toolbox bin to PATH ==="
cat >>~/.zshrc <<EOF

# toolbox/bin
export PATH="$(printf '%s:$%s' "$TOOLBOX_BIN_PATH" "PATH")"
EOF
