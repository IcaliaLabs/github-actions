FROM alpine:3.8

RUN apk add --no-cache git

COPY entrypoint.sh /usr/src/entrypoint.sh

ENTRYPOINT ["/usr/src/entrypoint.sh"]

LABEL "com.github.actions.name"="Assert Directory Changed"
LABEL "com.github.actions.description"="Checks if the contents of a certain directory changed during the commit"
LABEL "com.github.actions.icon"="help-circle"
LABEL "com.github.actions.color"="yellow"

LABEL "repository"="https://github.com/IcaliaLabs/github-actions.git"
LABEL "homepage"="https://github.com/IcaliaLabs/github-actions"
LABEL "maintainer"="Roberto Quintanilla <roberto.quintanilla@gmail.com>"
