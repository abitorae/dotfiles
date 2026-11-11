#!/bin/bash
# ~/.local/share/darkman/30-graphical.sh

set -eu

trap 'sleep 1; hyprctl dispatch "hl.dsp.dpms({ action = '\'enable\'' })"' EXIT

MODE="$1"

[ -f /tmp/darkman_skip_theme ] && exit 0
echo "HYPRLAND_INSTANCE_SIGNATURE=$HYPRLAND_INSTANCE_SIGNATURE" >> /tmp/darkman_env.log

case "$MODE" in
  dark)
    GTK_THEME="rose-pine-gtk"
    GTK_CURSOR_THEME="BreezeX-RosePine-Linux"
    QT_THEME="rose-pine-rose"
    SPOTIFY_THEME="rose-pine"
    ;;
  light)
    GTK_THEME="rose-pine-dawn-gtk"
    GTK_CURSOR_THEME="BreezeX-RosePineDawn-Linux"
    QT_THEME="rose-pine-dawn-rose"
    SPOTIFY_THEME="rose-pine-dawn"
    ;;
esac

# GTK
gsettings set org.gnome.desktop.interface color-scheme "prefer-${MODE}"
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface cursor-theme "$GTK_CURSOR_THEME"

# QT
# sed -i "s/^theme=.*/theme=${QT_THEME}/" ~/.config/Kvantum/kvantum.kvconfig
ln -sfn "${HOME}/.config/Kvantum/${QT_THEME}/${QT_THEME}.kvconfig" "${HOME}/.config/Kvantum/current/current.kvconfig"
ln -sfn "${HOME}/.config/Kvantum/${QT_THEME}/${QT_THEME}.svg" "${HOME}/.config/Kvantum/current/current.svg"

# Spotify
spicetify config color_scheme "$SPOTIFY_THEME"
spicetify apply
