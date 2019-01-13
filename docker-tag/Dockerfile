FROM docker:stable

COPY entrypoint.sh /usr/local/sbin/docker-tag

ENTRYPOINT [ "/usr/local/sbin/docker-tag" ]

LABEL "repository"="https://github.com/IcaliaLabs/github-actions.git" \
      "homepage"="https://github.com/IcaliaLabs/github-actions" \
      "maintainer"="Roberto Quintanilla <roberto.quintanilla@gmail.com>" \
      "version"="0.0.1" \
      "com.github.actions.name"="Docker Tag" \
      "com.github.actions.description"="Shell-only implementation of actions/docker/tag" \
      "com.github.actions.icon"="package" \
      "com.github.actions.color"="blue"
