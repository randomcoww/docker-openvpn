FROM alpine:edge

RUN set -x \
  \
  && apk add --no-cache \
    openvpn \
    bash \
    shadow

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
