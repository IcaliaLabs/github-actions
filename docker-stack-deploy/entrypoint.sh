#! /bin/sh

# Exit immediately if a command exits with a non-zero status:
set -e

: ${STACK_NAME:=$1}
: ${STACK_FILE:=$2}

DOCKER_OPTIONS=""
DEPLOY_OPTIONS=""

write_pkey_to_file() {
  echo "- Writing SSH private key..."
  echo "${DOCKER_STACK_DEPLOY_SSH_KEY}" > /tmp/ssh-key.pem
  chmod 0600 /tmp/ssh-key.pem
}

create_tunnel_to_manager() {
  echo "- Opening SSH tunnel to Swarm manager's Docker socket at '${DOCKER_STACK_DEPLOY_MANAGER_HOSTNAME}'..."
  ssh -i /tmp/ssh-key.pem -o StrictHostKeyChecking=no -NL localhost:2374:/var/run/docker.sock "docker@${DOCKER_STACK_DEPLOY_MANAGER_HOSTNAME}" &
  sleep 1s
  DOCKER_OPTIONS="-H localhost:2374"
}

test_docker_swarm_connection() {
  ls -lah /var/run/
  echo "- Getting remote swarm info..."
  docker ${DOCKER_OPTIONS} info
}

connect_to_swarm() {
  echo "Connecting to Swarm:"
  write_pkey_to_file
  create_tunnel_to_manager
  test_docker_swarm_connection
}

set_deploy_options() {
  set_with_registry_auth_option
  set_compose_file_option
  set_prune_option
}

set_with_registry_auth_option() {
  if [ "${DOCKER_STACK_DEPLOY_WITH_REGISTRY_AUTH}" = 'yes' ]; then
    DEPLOY_OPTIONS="${DEPLOY_OPTIONS} --with-registry-auth"
  fi
}

set_compose_file_option() {
  DEPLOY_OPTIONS="${DEPLOY_OPTIONS} --compose-file ${STACK_FILE}"
}

set_prune_option() {
  DEPLOY_OPTIONS="${DEPLOY_OPTIONS} --prune"
}

connect_to_swarm
set_deploy_options
echo "Running: 'docker ${DOCKER_OPTIONS} stack deploy ${DEPLOY_OPTIONS} ${STACK_NAME}'"
docker ${DOCKER_OPTIONS} stack deploy ${DEPLOY_OPTIONS} ${STACK_NAME}
