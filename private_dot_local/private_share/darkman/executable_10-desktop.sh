#!/bin/bash
# ~/.local/share/darkman/10-desktop.sh

set -eu

MODE="$1"

confirm_switch() {
  local mode="$1"
  if command -v zenity >/dev/null 2>&1; then
    zenity --question \
      --title="主题切换" \
      --text="当前时间满足${mode}模式条件，是否切换主题？" \
      && return 0 || return 1
  else
    notify-send "主题切换" "自动切换为${mode}主题（无确认工具，直接执行）"
    return 0
  fi
}

if ! confirm_switch "$MODE"; then
  touch /tmp/darkman_skip_theme
  exit 0
fi
rm -f /tmp/darkman_skip_theme

hyprctl dispatch "hl.dsp.dpms({ action = 'disable' })"
sleep 1
trap 'hyprctl dispatch "hl.dsp.dpms({ action = '\'enable\'' })" 2>/dev/null || true' ERR

echo "SIG=$HYPRLAND_INSTANCE_SIGNATURE PID=$$" >> /tmp/darkman_env.log
env | grep -E 'HYPRLAND|WAYLAND' >> /tmp/darkman_env.log

case "$MODE" in
  dark)
    FCITX5_THEME="rose-pine"
    FOOT_MODE="-SIGUSR1"
    FUZZEL_THEME="rose-pine.ini"
    SWAY_THEME="rose-pine.theme"
    SWAY_WALLPAPER="swaylock-dark.png"
    SWAYLOCK_THEME="rose-pine"
    MAKO_THEME="rose-pine.theme"
    HELIX_THEME="rose_pine.toml"
    ;;
  light)
    FCITX5_THEME="rose-pine-dawn"
    FOOT_MODE="-SIGUSR2"
    FUZZEL_THEME="rose-pine-dawn.ini"
    SWAY_THEME="rose-pine-dawn.theme"
    SWAY_WALLPAPER="swaylock-light.png"
    SWAYLOCK_THEME="rose-pine-dawn"
    MAKO_THEME="rose-pine-dawn.theme"
    HELIX_THEME="rose_pine_dawn.toml"
    ;;
esac

# Foot
if pgrep -x foot; then
  pkill "$FOOT_MODE" -x foot
fi

# Fcitx5
ln -sfn "${HOME}/.local/share/fcitx5/themes/${FCITX5_THEME}" "${HOME}/.local/share/fcitx5/themes/current"
fcitx5 -r &


# Sway
# ln -sfn "${HOME}/.config/sway/themes/${SWAY_THEME}" "${HOME}/.config/sway/themes/current.theme"
# Sway wallpaper
# ln -sfn "${HOME}/.config/wallpapers/${SWAY_WALLPAPER}" "${HOME}/.config/wallpapers/sway.png"
# Swaybar
# declare -A colors

# while read -r name value; do
# colors[${name#\$}]="$value"
# done < <(
# awk '/^set / {print $2, $3}' "${HOME}/.config/sway/themes/${SWAY_THEME}"
# )

# template=~/.config/sway/templates/swaybar.template
# output=~/.config/sway/config.d/swaybar.conf

# cp "$template" "$output"

# for key in "${!colors[@]}"; do
#     sed -i "s|{{$key}}|${colors[$key]}|g" "$output"
# done

# if grep -q '{{.*}}' "$output"; then
# echo "ERROR: unresolved template variables"
# grep '{{.*}}' "$output"
# exit 1
# fi
# swaymsg reload &


# Swaylock
# ln -sf "${HOME}/.config/swaylock/themes/${SWAYLOCK_THEME}" "${HOME}/.config/swaylock/config"

# Mako
# ln -sf "${HOME}/.config/mako/themes/${MAKO_THEME}" "${HOME}/.config/mako/config"

# Fuzzel
ln -sf "${HOME}/.config/fuzzel/themes/${FUZZEL_THEME}" "${HOME}/.config/fuzzel/fuzzel.ini"

# Helix
ln -sf "${HOME}/.config/helix/themes/${HELIX_THEME}" "${HOME}/.config/helix/themes/current.toml"

