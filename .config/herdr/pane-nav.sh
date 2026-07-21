#!/usr/bin/env bash
#
# pane-nav.sh — seamless Ctrl+h/j/k/l navigation between herdr panes and
# Vim/Neovim splits. Standalone (no herdr plugin); bound directly from
# config.toml as `type = "shell"` custom commands.
#
# Usage: pane-nav.sh <left|down|up|right>
#
# When the focused pane runs Vim/Neovim in the foreground, forward the matching
# Ctrl chord so Vim moves between its own splits. Vim's own config, at a split
# edge, calls back into `herdr pane focus` to cross the pane boundary. For any
# other foreground process, move herdr's pane focus directly.
#
# Requires `jq`. Without it, detection is skipped and every key moves the herdr
# pane focus (no Vim awareness).

set -euo pipefail

dir="${1:?usage: pane-nav.sh <left|down|up|right>}"
herdr="${HERDR_BIN_PATH:-herdr}"

# Keybind context exposes the focused pane as HERDR_ACTIVE_PANE_ID; an in-pane
# shell exposes HERDR_PANE_ID. Prefer whichever is set.
pane="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}"

case "$dir" in
  left)  key="ctrl+h" ;;
  down)  key="ctrl+j" ;;
  up)    key="ctrl+k" ;;
  right) key="ctrl+l" ;;
  *) echo "pane-nav.sh: unknown direction: $dir" >&2; exit 2 ;;
esac

# Foreground process names that mean "Vim is in control of this pane".
# Same matcher vim-tmux-navigator uses: vi, vim, nvim, view, gvim, *diff, ...
vim_re='^g?(view|l?n?vim?x?)(diff)?$'

forward=0
if command -v jq >/dev/null 2>&1; then
  info="$("$herdr" pane process-info --current 2>/dev/null || true)"
  if printf '%s' "$info" \
    | jq -e --arg vim "$vim_re" \
        '.result.process_info.foreground_processes[]?.name
         | ascii_downcase
         | select(test($vim))' >/dev/null 2>&1; then
    forward=1
  fi
  # Fall back to the focused pane id if the keybind env didn't provide one.
  if [ -z "$pane" ]; then
    pane="$(printf '%s' "$info" | jq -r '.result.process_info.pane_id // empty' 2>/dev/null || true)"
  fi
fi

if [ "$forward" -eq 1 ] && [ -n "$pane" ]; then
  exec "$herdr" pane send-keys "$pane" "$key"
else
  exec "$herdr" pane focus --direction "$dir" --current
fi
