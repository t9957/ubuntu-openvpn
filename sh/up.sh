#!/bin/sh
OUT_IF=$(ip route | awk '/default/ {print $5}')
sysctl -w net.ipv4.ip_forward=1

# NAT監視ループ
(while true; do
  if ! iptables -t nat -C POSTROUTING -s 10.8.0.0/24 -o "$OUT_IF" -j MASQUERADE 2>/dev/null; then
    echo "==> up.sh: iptables無し 設定実行"
    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o "$OUT_IF" -j MASQUERADE
  fi
  sleep 30
done) &