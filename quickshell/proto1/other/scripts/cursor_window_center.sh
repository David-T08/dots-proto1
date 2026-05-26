#!/usr/bin/env sh

addr="$1"

hyprctl clients -j | jq -r --arg addr "0x$addr" '
  .[] | select(.address == $addr) |
  "\(.at[0] + (.size[0] / 2 | floor)) \(.at[1] + (.size[1] / 2 | floor))"
' | while read -r x y; do
  hyprctl dispatch movecursor "$x" "$y"
done