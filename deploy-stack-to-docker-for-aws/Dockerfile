FROM docker:stable

RUN apk add --no-cache openssh-client

COPY entrypoint.sh /usr/src/entrypoint.sh

ENTRYPOINT ["/usr/src/entrypoint.sh"]

LABEL "repository"="https://github.com/IcaliaLabs/github-actions.git"
LABEL "homepage"="https://github.com/IcaliaLabs/github-actions"
LABEL "maintainer"="Roberto Quintanilla <roberto.quintanilla@gmail.com>"
LABEL "version"="0.0.1"

LABEL "com.github.actions.name"="Deploy Stack to Docker for AWS"
LABEL "com.github.actions.description"="Deploys a stack to a Docker for AWS Swarm"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"
