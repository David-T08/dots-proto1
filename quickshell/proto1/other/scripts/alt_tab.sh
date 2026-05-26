#!/usr/bin/env sh

STATE="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell-alttab-mode"
QS_PROTO="$HOME/.config/quickshell/proto1"

mkdir -p "$(dirname "$STATE")"

last_mode() {
    [ -f "$STATE" ] && cat "$STATE" || printf '%s\n' windows
}

call_alttab() {
    cmd="$1"
    mode="$2"
    qs -p "$QS_PROTO" ipc call floating alttab "$cmd" "$mode"
}

case "$1" in
    next)
        call_alttab next "$(last_mode)"
        ;;

    previous|prev)
        call_alttab previous "$(last_mode)"
        ;;

    accept)
        call_alttab accept "$(last_mode)"
        ;;

    hide)
        call_alttab hide "$(last_mode)"
        ;;

    windows|workspace-windows|monitor-windows|workspaces|monitor-workspaces|screens)
        printf '%s\n' "$1" > "$STATE"
        call_alttab mode "$1"
        ;;

    *)
        echo "Usage: $0 {next|previous|accept|hide|windows|workspace-windows|monitor-windows|workspaces|monitor-workspaces|screens}" >&2
        exit 2
        ;;
esac