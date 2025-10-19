FROM ubuntu:24.04

RUN apt update
RUN apt install -y --no-install-recommends ca-certificates curl gnupg lsb-release
RUN apt install -y --no-install-recommends procps iproute2 iptables

RUN apt install -y --no-install-recommends openvpn
RUN apt install -y --no-install-recommends easy-rsa

RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

CMD bash -c "\
  /etc/openvpn/sh/preparation.sh && \
  ln -sf /etc/openvpn/sh/new_client.sh /usr/local/bin/new-client && \
  chmod +x /etc/openvpn/sh/new_client.sh && \
  exec openvpn --config /etc/openvpn/server.conf"