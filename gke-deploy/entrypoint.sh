#! /bin/sh

# Exit immediately if a command exits with a non-zero status:
set -e


GCLOUD_ZONE=${GCLOUD_ZONE:-$PLUGIN_ZONE}
GCLOUD_PROJECT=${GCLOUD_PROJECT:-$PLUGIN_PROJECT}
GCLOUD_CLUSTER=${GCLOUD_CLUSTER:-$PLUGIN_CLUSTER}
DEPLOY_IMAGE=${DEPLOY_IMAGE:-$PLUGIN_DEPLOY_IMAGE}
JSON_KEY=${JSON_KEY:-$PLUGIN_JSON_KEY}

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

# Step 1:
activate_gcloud_service_account

# # Step 2:
configure_kubectl

# # Step 3:
kubectl get pods
