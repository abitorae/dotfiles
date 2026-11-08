#!/bin/bash
# ~/.local/share/darkman/20-terminal.sh

set -eu

MODE="$1"

case "$MODE" in
  dark)
    BTOP_THEME="rose-pine.theme"
    YAZI_ICON_THEME="rose-pine.toml"
    ;;
  light)
    BTOP_THEME="rose-pine-dawn.theme"
    YAZI_ICON_THEME="rose-pine-dawn.toml"
    ;;
esac

# Btop
ln -sf "${HOME}/.config/btop/themes/${BTOP_THEME}" "${HOME}/.config/btop/themes/current.theme"

# Yazi icon
# cat "${HOME}/.config/yazi/themes/${YAZI_ICON_THEME}" >> "${HOME}/.config/yazi/theme.toml"
