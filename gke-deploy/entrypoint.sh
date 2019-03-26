#! /bin/sh

# Exit immediately if a command exits with a non-zero status:
set -e


GCLOUD_ZONE=${GCLOUD_ZONE:-$PLUGIN_ZONE}
GCLOUD_PROJECT=${GCLOUD_PROJECT:-$PLUGIN_PROJECT}
GCLOUD_CLUSTER=${GCLOUD_CLUSTER:-$PLUGIN_CLUSTER}
DEPLOY_IMAGE=${DEPLOY_IMAGE:-$PLUGIN_DEPLOY_IMAGE}


write_key_to_file() {
  if [ -z "${DOCKER_STACK_DEPLOY_SSH_KEY}" ]
  then
    echo "Error: Looks like the SSH key is empty!"
    exit 1
  fi

  echo "- Writing SSH private key..."
  echo "${DOCKER_STACK_DEPLOY_SSH_KEY}" > /tmp/ssh-key.pem
  chmod 0600 /tmp/ssh-key.pem
}

printenv

echo "============= GCLOUD_CLUSTER: ${GCLOUD_CLUSTER} ============="
echo "============= GCLOUD_ZONE: ${GCLOUD_ZONE} ============="
echo "============= GCLOUD_PROJECT: ${GCLOUD_PROJECT} ============="
echo "============= Deploy image: ${DEPLOY_IMAGE} ============="

pwd
ls -lah /drone

# # Step 1:
# gcloud auth activate-service-account --key-file tmp/production-232221-dc4143c1322a.json

# # Step 2:
# gcloud container clusters get-credentials staging-cluster --zone us-central1-a --project production-232221

# # Step 3:
# kubectl apply -f ...
