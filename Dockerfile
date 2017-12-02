FROM alpine:latest

RUN \
  apk add --no-cache openvpn bash

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
