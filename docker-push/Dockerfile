FROM docker:stable

COPY entrypoint.sh /usr/local/sbin/docker-push

ENTRYPOINT [ "/usr/local/sbin/docker-push" ]

LABEL "repository"="https://github.com/IcaliaLabs/github-actions.git" \
      "homepage"="https://github.com/IcaliaLabs/github-actions" \
      "maintainer"="Roberto Quintanilla <roberto.quintanilla@gmail.com>" \
      "version"="0.0.1" \
      "com.github.actions.name"="Docker Push" \
      "com.github.actions.description"="Shell-only implementation of actions/docker/push" \
      "com.github.actions.icon"="package" \
      "com.github.actions.color"="blue"
