FROM node:dubnium-alpine

RUN npm install -g heroku

COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]

# COPY --from=docker:stable /usr/local/bin/* /usr/local/bin/

LABEL "version"="0.0.1" \
      "repository"="http://github.com/IcaliaLabs/github-actions" \
      "homepage"="http://github.com/IcaliaLabs/github-actions" \
      "maintainer"="Roberto Quintanilla <vovimayhem@users.github.com>" \
      "com.github.actions.name"="GitHub Action for Heroku" \
      "com.github.actions.description"="Wraps the Heroku CLI to enable common Heroku commands." \
      "com.github.actions.icon"="upload-cloud" \
      "com.github.actions.color"="purple"
