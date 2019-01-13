FROM docker:stable

RUN apk add --no-cache openssh-client

COPY entrypoint.sh /usr/local/sbin/docker-stack-deploy

ENTRYPOINT [ "/usr/local/sbin/docker-stack-deploy" ]

LABEL "repository"="https://github.com/IcaliaLabs/github-actions.git" \
      "homepage"="https://github.com/IcaliaLabs/github-actions" \
      "maintainer"="Roberto Quintanilla <roberto.quintanilla@gmail.com>" \
      "version"="0.0.1" \
      "com.github.actions.name"="Docker Stack Deploy" \
      "com.github.actions.description"="Deploys a stack to a Docker Swarm/K8" \
      "com.github.actions.icon"="package" \
      "com.github.actions.color"="blue"
