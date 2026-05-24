#!/usr/bin/env bash

STATE="/tmp/quickshell-sys-stats-$UID"
IFACE="${1:-$(ip route get 1.1.1.1 2>/dev/null | awk '{print $5; exit}')}"

read_cpu() {
  awk '/^cpu / {
    idle=$5
    total=0
    for (i=2; i<=NF; i++) total += $i
    print idle, total
  }' /proc/stat
}

read_net() {
  awk -v iface="$IFACE:" '$1 == iface {
    gsub(":", "", $1)
    print $2, $10
  }' /proc/net/dev
}

read idle total < <(read_cpu)
read rx tx < <(read_net)

if [[ -f "$STATE" ]]; then
  read old_idle old_total old_rx old_tx old_time < "$STATE"
else
  old_idle=$idle
  old_total=$total
  old_rx=$rx
  old_tx=$tx
  old_time=$(date +%s)
fi

now=$(date +%s)
dt=$((now - old_time))
(( dt <= 0 )) && dt=1

cpu_delta=$((total - old_total))
idle_delta=$((idle - old_idle))

cpu=$(awk -v c="$cpu_delta" -v i="$idle_delta" 'BEGIN {
  if (c <= 0) print 0;
  else printf "%.0f", (100 * (c - i)) / c
}')

ram=$(free -b | awk '/Mem:/ { printf "%.1fG", $3 / 1024 / 1024 / 1024 }')

temp=$(awk '{ printf "%.0f°", $1 / 1000 }' /sys/class/thermal/thermal_zone0/temp 2>/dev/null)

down=$(awk -v n="$((rx - old_rx))" -v dt="$dt" 'BEGIN {
  v=n/dt
  if (v>=1048576) printf "%.1fM", v/1048576
  else if (v>=1024) printf "%.0fK", v/1024
  else printf "%.0fB", v
}')

up=$(awk -v n="$((tx - old_tx))" -v dt="$dt" 'BEGIN {
  v=n/dt
  if (v>=1048576) printf "%.1fM", v/1048576
  else if (v>=1024) printf "%.0fK", v/1024
  else printf "%.0fB", v
}')

echo "$idle $total $rx $tx $now" > "$STATE"

echo "CPU:$cpu|RAM:$ram|TMP:${temp:-N/A}|DOWN:$down|UP:$up"