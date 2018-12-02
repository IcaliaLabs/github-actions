#! /bin/sh

# Exit immediately if a command exits with a non-zero status:
set -e

: ${STACK_NAME:=$1}
: ${STACK_FILE:=$2}

DEPLOY_OPTIONS=""

write_pkey_to_file() {
  echo "- Writing SSH private key..."
  echo "${DOCKER_FOR_AWS_SSH_KEY}" > /tmp/ssh-key.pem
  chmod 0600 /tmp/ssh-key.pem
}

create_tunnel_to_manager() {
  echo "- Opening SSH tunnel to Swarm manager's Docker socket at '${SWARM_MANAGER_PUBLIC_DNS}'..."
  ssh -i /tmp/ssh-key.pem -o StrictHostKeyChecking=no -NL localhost:2374:/var/run/docker.sock "docker@${SWARM_MANAGER_PUBLIC_DNS}" &
  sleep 1s
}

test_docker_swarm_connection() {
  ls -lah /var/run/
  echo "- Getting remote swarm info..."
  docker -H localhost:2374 info
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
  if [ "${DEPLOY_IMAGES_REQUIRE_AUTH}" = 'yes' ]; then
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
echo "Running: 'docker stack deploy ${DEPLOY_OPTIONS} ${STACK_NAME}'"
docker stack deploy ${DEPLOY_OPTIONS} ${STACK_NAME}
