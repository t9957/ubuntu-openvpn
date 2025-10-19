#!/bin/sh
# up.sh : コンテナ内でNAT設定を行う

# コンテナ内でのethデバイスを自動検出
OUT_IF=$(ip route | awk '/default/ {print $5}')

# IP転送有効化
sysctl -w net.ipv4.ip_forward=1

# NAT有効化
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o $OUT_IF -j MASQUERADE
