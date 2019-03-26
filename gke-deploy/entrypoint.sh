#! /bin/sh

# Exit immediately if a command exits with a non-zero status:
set -e


JSON_KEY=${JSON_KEY:-$PLUGIN_JSON_KEY}
GCLOUD_ZONE=${GCLOUD_ZONE:-$PLUGIN_ZONE}
GCLOUD_PROJECT=${GCLOUD_PROJECT:-$PLUGIN_PROJECT}
GCLOUD_CLUSTER=${GCLOUD_CLUSTER:-$PLUGIN_CLUSTER}
DEPLOY_TEMPLATE=${DEPLOY_TEMPLATE:-$PLUGIN_DEPLOY_TEMPLATE}

DEPLOY_IMAGE_TAG=${COMMIT_SHA:-$DRONE_COMMIT_SHA}

write_key_to_file() {
  if [ -z "${JSON_KEY}" ]
  then
    echo "Error: Looks like the json key is empty!"
    exit 1
  fi

  echo "- Writing json key..."
  echo "${JSON_KEY}" > /tmp/json_key.json
}

activate_gcloud_service_account() {
  write_key_to_file
  gcloud auth activate-service-account --key-file /tmp/json_key.json
}

configure_kubectl() {
  gcloud container clusters get-credentials $GCLOUD_CLUSTER \
    --zone $GCLOUD_ZONE \
    --project $GCLOUD_PROJECT
}

evaluate_template() {
  if [ -z "${DEPLOY_IMAGE_TAG}" ]; then DEPLOY_IMAGE_TAG=latest; fi

  if [ ! -f "${DEPLOY_TEMPLATE}" ]
  then
    echo "Error: Looks like there's no deploy template!"
    exit 1
  fi

  sed "s+{{image-tag}}+${DEPLOY_IMAGE_TAG}+g" $DEPLOY_TEMPLATE > /tmp/deploy.yml
}

apply_and_wait_for_rollout() {
  evaluate_template
  kubectl apply -f /tmp/deploy.yml
  kubectl rollout status deployment/${GCLOUD_PROJECT}
}

# Step 1:
activate_gcloud_service_account

# Step 2:
configure_kubectl

# Step 3:
apply_and_wait_for_rollout
