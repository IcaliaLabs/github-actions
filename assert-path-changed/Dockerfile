FROM alpine:3.8

RUN apk add --no-cache git

COPY entrypoint.sh /usr/src/entrypoint.sh

ENTRYPOINT ["/usr/src/entrypoint.sh"]

LABEL "com.github.actions.name"="Assert Path Changed" \
      "com.github.actions.description"="Checks if a certain path changed during the commit" \
      "com.github.actions.icon"="help-circle" \
      "com.github.actions.color"="yellow" \
      "repository"="https://github.com/IcaliaLabs/github-actions.git" \
      "homepage"="https://github.com/IcaliaLabs/github-actions" \
      "maintainer"="Roberto Quintanilla <roberto.quintanilla@gmail.com>" \
      "version"="0.0.1"
