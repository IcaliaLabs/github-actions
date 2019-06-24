FROM docker/compose:1.24.0

RUN wget -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 \
 && chmod a+x /usr/local/bin/yq

COPY entrypoint.sh /usr/local/sbin/docker-image-manager

ENTRYPOINT [ "/usr/local/sbin/docker-image-manager" ]