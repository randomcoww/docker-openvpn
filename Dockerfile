FROM alpine:edge

WORKDIR /etc/openvpn

RUN set -x \
  \
  && wget -O openvpn.zip https://www.privateinternetaccess.com/openvpn/openvpn.zip \
  && unzip openvpn.zip \
  && rm openvpn.zip \
  \
  && apk add --no-cache \
    openvpn \
    shadow

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
