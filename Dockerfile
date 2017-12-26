FROM alpine:latest

RUN set -x \
  \
  && apk add --no-cache \
    openvpn \
    bash

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
