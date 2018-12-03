#!/bin/sh

set -e

HEROKU_COMMAND="heroku $*"

if [ ! -z "${HEROKU_WORKDIR}" ]; then
  HEROKU_COMMAND="cd ${HEROKU_WORKDIR} && ${HEROKU_COMMAND}"
fi

echo "Executing: '${HEROKU_COMMAND}'"
sh -c "${HEROKU_COMMAND}"
