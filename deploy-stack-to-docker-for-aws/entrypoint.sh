#! /bin/sh

: ${STACK_NAME:=$1}
: ${STACK_FILE:=$2}

DEPLOY_OPTIONS=""

write-pkey-to-file() {
  echo ${DOCKER_FOR_AWS_SSH_KEY} > /tmp/ssh-key.pem
  chmod 0600 /tmp/ssh-key.pem
  echo "- Wrote SSH private key"
}

create-tunnel-to-manager() {
  ssh -i /tmp/ssh-key.pem -NL localhost:2374:/var/run/docker.sock "docker@${SWARM_MANAGER_PUBLIC_DNS}" &
  echo "- Opened tunnel to Swarm manager's Docker socket at '${SWARM_MANAGER_PUBLIC_DNS}' to 'localhost:2374'"
}

set-docker-host-to-manager() {
  export DOCKER_HOST="localhost:2374"
  echo "- Set 'DOCKER_HOST' env var to 'localhost:2374'"
}

connect-to-swarm() {
  echo "Connecting to Swarm:"
  write-pkey-to-file
  create-tunnel-to-manager
  set-docker-host-to-manager
}

set-deploy-options() {
  set-with-registry-auth-option
  set-compose-file-option
  set-prune-option
}

set-with-registry-auth-option() {
  if [ "${DEPLOY_IMAGES_REQUIRE_AUTH}" = 'yes' ]; then
    DEPLOY_OPTIONS="${DEPLOY_OPTIONS} --with-registry-auth"
  fi
}

set-compose-file-option() {
  DEPLOY_OPTIONS="${DEPLOY_OPTIONS} --compose-file ${STACK_FILE}"
}

set-prune-option() {
  DEPLOY_OPTIONS="${DEPLOY_OPTIONS} --prune"
}

connect-to-swarm
set-deploy-options
exec "docker stack deploy ${DEPLOY_OPTIONS} ${STACK_NAME}"
