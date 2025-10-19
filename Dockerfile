FROM ubuntu:24.04

RUN apt update
RUN apt install -y --no-install-recommends ca-certificates curl gnupg lsb-release
RUN apt install -y --no-install-recommends procps iproute2 iptables

RUN apt install -y --no-install-recommends openvpn
RUN apt install -y --no-install-recommends easy-rsa

RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

# COPY ./preparation.sh /usr/src/sh/preparation.sh
# RUN chmod +x /usr/src/sh/preparation.sh

CMD bash -c "/usr/src/sh/preparation.sh && exec openvpn --config /etc/openvpn/server.conf"
