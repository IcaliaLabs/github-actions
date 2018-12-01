FROM alpine:3.8

RUN apk add --no-cache git

COPY entrypoint.sh /usr/src/entrypoint.sh

ENTRYPOINT ["/usr/src/entrypoint.sh"]
