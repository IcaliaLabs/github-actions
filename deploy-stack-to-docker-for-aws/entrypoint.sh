#! /bin/sh

: ${STACK_NAME:=$1}
: ${STACK_FILE:=$2}

DEPLOY_OPTIONS=""

write_pkey_to_file() {
  echo ${DOCKER_FOR_AWS_SSH_KEY} > /tmp/ssh-key.pem
  chmod 0600 /tmp/ssh-key.pem
  echo "- Wrote SSH private key:"
  echo ${DOCKER_FOR_AWS_SSH_KEY}
}

test_ssh_connection() {
  echo "- Testing the SSH Connection: Listing swarm nodes..."
  ssh -i /tmp/ssh-key.pem "docker@${SWARM_MANAGER_PUBLIC_DNS}" docker node ls
}

create_tunnel_to_manager() {
  ssh -i /tmp/ssh-key.pem -NL localhost:2374:/var/run/docker.sock "docker@${SWARM_MANAGER_PUBLIC_DNS}" &
  echo "- Opened tunnel to Swarm manager's Docker socket at '${SWARM_MANAGER_PUBLIC_DNS}' to 'localhost:2374'"
}

set_docker_host_to_manager() {
  export DOCKER_HOST="localhost:2374"
  echo "- Set 'DOCKER_HOST' env var to 'localhost:2374'"
}

connect_to_swarm() {
  echo "Connecting to Swarm:"
  write_pkey_to_file
  test_ssh_connection
  create_tunnel_to_manager
  set_docker_host_to_manager
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
echo "DOCKER_HOST=${DOCKER_HOST}"
echo "DOCKER = `which docker`"
docker stack deploy ${DEPLOY_OPTIONS} ${STACK_NAME}
