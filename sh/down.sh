#!/bin/sh
# down.sh : コンテナ停止時にNAT削除
OUT_IF=$(ip route | awk '/default/ {print $5}')
iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -o $OUT_IF -j MASQUERADE
