#!/bin/bash
CA_DIR="/etc/openvpn/ca/easyrsa"

CLIENT_NAME=$1
if [ -z "$1" ]; then
  read -p "input client_name: " INPUT
  CLIENT_NAME=$INPUT
fi

cd "$CA_DIR"/pki
rm -f reqs/${CLIENT_NAME}.req issued/${CLIENT_NAME}.crt private/${CLIENT_NAME}.key
cd $CA_DIR

./easyrsa --batch gen-req "$CLIENT_NAME" nopass
./easyrsa --batch sign-req client "$CLIENT_NAME"

chmod 600 ${CA_DIR}/pki/private/${CLIENT_NAME}.key
chmod 644 ${CA_DIR}/pki/issued/${CLIENT_NAME}.crt

echo "=> easyrsa done"

cat > /etc/openvpn/clients/"$CLIENT_NAME".ovpn <<EOF
client
dev tun
proto udp
remote ${VPN_GLOBAL_IP} ${VPN_PORT}
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-GCM
verb 3
key-direction 1

<ca>
$(cat "$CA_DIR"/pki/ca.crt)
</ca>

<cert>
$(cat "$CA_DIR"/pki/issued/"$CLIENT_NAME".crt)
</cert>

<key>
$(cat "$CA_DIR"/pki/private/"$CLIENT_NAME".key)
</key>

<tls-auth>
$(cat "$CA_DIR"/ta.key)
</tls-auth>
EOF

echo "=> EOF done"