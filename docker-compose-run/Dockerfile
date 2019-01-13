FROM docker:dind

ENV GLIBC=2.28-r0 DOCKER_COMPOSE_VERSION=1.23.2

RUN apk update && apk add --no-cache openssl ca-certificates curl libgcc && \
    curl -fsSL -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    curl -fsSL -o glibc-$GLIBC.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk && \
    apk add --no-cache glibc-$GLIBC.apk && \
    ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ && \
    ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib && \
    ln -s /usr/lib/libgcc_s.so.1 /usr/glibc-compat/lib && \
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-$GLIBC.apk

RUN curl \
    -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) \
    -o /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose

COPY entrypoint.sh /usr/local/bin/docker-compose-entrypoint.sh

WORKDIR /usr/src

ENTRYPOINT ["/usr/local/bin/docker-compose-entrypoint.sh"]

LABEL "repository"="https://github.com/IcaliaLabs/github-actions.git" \
      "homepage"="https://github.com/IcaliaLabs/github-actions" \
      "maintainer"="Roberto Quintanilla <roberto.quintanilla@gmail.com>" \
      "version"="0.0.1" \
      "com.github.actions.name"="Docker Compose Run" \
      "com.github.actions.description"="Runs commands on a Docker Compose stack" \
      "com.github.actions.icon"="package" \
      "com.github.actions.color"="blue"
