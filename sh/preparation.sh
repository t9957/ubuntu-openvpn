#!/bin/bash
set -e
echo "==> preparation.sh: 開始"

CONF_DIR="/etc/openvpn"

cd "$CONF_DIR"


if [ ! -d "$CONF_DIR/ca" ]; then

  echo "==> preparation.sh: dir:ca無し"

  make-cadir ca
  cd ca
  
  echo 'set_var EASYRSA_REQ_COUNTRY    "JP"' >> vars
  echo 'set_var EASYRSA_REQ_PROVINCE   "Tokyo"' >> vars
  echo 'set_var EASYRSA_REQ_CITY       "Tokyo"' >> vars
  echo 'set_var EASYRSA_REQ_ORG        "LocalVPN"' >> vars
  echo 'set_var EASYRSA_REQ_EMAIL      "admin@example.com"' >> vars
  echo 'set_var EASYRSA_REQ_OU         "SelfSigned"' >> vars
  
  echo "==> preparation.sh: vars設定完了"
  
  ./easyrsa init-pki
  echo "==> preparation.sh: init-pki完了"

  echo "==> CA作成中..."
  ./easyrsa --batch build-ca nopass > /dev/null 2>&1
  
  echo "==> サーバ証明書作成中..."
  ./easyrsa --batch gen-req server nopass > /dev/null 2>&1
  ./easyrsa --batch sign-req server server > /dev/null 2>&1
  
  echo "==> DHパラメータ作成中..."
  ./easyrsa gen-dh > /dev/null 2>&1


  openvpn --genkey secret ta.key
  echo "==> preparation.sh: genkey完了"

  cp pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem ta.key /
  echo "==> preparation.sh: cp完了"
  else
  echo "==> preparation.sh: dir:ca有り"
fi
