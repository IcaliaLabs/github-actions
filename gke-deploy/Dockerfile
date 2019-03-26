# Based on:
# - https://www.jeffgeerling.com/blog/2018/install-kubectl-your-docker-image-easy-way
# - https://github.com/nytimes/drone-gke

# Read more on:
# - https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl
# - https://cloud.google.com/sdk/docs/authorizing#authorizing_with_a_service_account
# 1: We supposedly need gcloud sdk to do stuff such as auth to the cluster:
FROM google/cloud-sdk:alpine

# 2: Copy the kubectl from the hub:
COPY --from=lachlanevenson/k8s-kubectl:v1.14.0 /usr/local/bin/kubectl /usr/local/bin/kubectl

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
