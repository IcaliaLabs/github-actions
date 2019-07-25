#!/bin/sh

GIVEN_COMMAND=$1

TAG_SAFE_BRANCH=$(echo ${GIT_BRANCH} | tr '/' '-')
GIT_SHORT_SHA=${GIT_SHA:0:7}

function download_cache()
{
  SERVICE_NAME=$1

  echo "$@" | grep -qe '--break-on-first' && BREAK_ON_FIRST="yes" || BREAK_ON_FIRST="no"

  if [ "${BREAK_ON_FIRST}" == 'no' ]
  then
    echo "DEPRECATION WARNING: The behavior of download-cache will change in newer versions, stopping on the first pulled image."
    echo "Ensure your'e using the '--break-on-first' option to switch to the new behavior!"
  fi

  for image_name in $(TAG_SAFE_BRANCH=${TAG_SAFE_BRANCH} docker-compose --file ${COMPOSE_FILE} config | yq -t r - services.${SERVICE_NAME}.build.cache_from)
  do
    if [ "${image_name}" == "-" ]; then continue; fi
    echo "Attempt to pull image '${image_name}':"
    docker pull ${image_name}

    pull_status=$?

    if [ $pull_status -ne 0 ]; then echo "cache miss"; fi

    # If pull was successful, and the "break on first" flag is set, break off
    # the loop:
    if [ $pull_status -eq 0 ] && [ "${BREAK_ON_FIRST}" == 'yes' ]; then break; fi
  done
}

function tag_and_push_one()
{
  SOURCE_IMAGE=$1
  TARGET_IMAGE=$2

  docker tag ${SOURCE_IMAGE} ${TARGET_IMAGE}
  docker push ${TARGET_IMAGE}
}

function tag_and_push()
{
  SERVICE_NAME=$1
  IMAGE_NAME=$2
  SOURCE_IMAGE=$(docker-compose --file ${COMPOSE_FILE} config | yq -t r - services.${SERVICE_NAME}.image)
  SOURCE_IMAGE_TAG=$(echo ${SOURCE_IMAGE} | sed -E "s/^(.+):(.+)$/\2/")
  
  # 1: Tag with the branch name:
  if [ "${SOURCE_IMAGE_TAG}" == "latest" ]
  then
    BRANCH_NAME_TAG="${IMAGE_NAME}:${TAG_SAFE_BRANCH}"
  else
    if [ "${GIT_BRANCH}" == "master" ]
    then
      BRANCH_NAME_TAG="${IMAGE_NAME}:${SOURCE_IMAGE_TAG}"
    else
      BRANCH_NAME_TAG="${IMAGE_NAME}:${SOURCE_IMAGE_TAG}-${TAG_SAFE_BRANCH}"
    fi
  fi
  tag_and_push_one ${SOURCE_IMAGE} ${BRANCH_NAME_TAG}

  # 2: Tag with the Git short SHA:
  echo "$@" | grep -qe '--skip-git-sha' && SKIP_GIT_SHA="yes" || SKIP_GIT_SHA="no"
  if [ ${SKIP_GIT_SHA} == "no" ] 
  then
    if [ "${SOURCE_IMAGE_TAG}" == "latest" ]
    then
      SHORT_GIT_SHA_TAG="${IMAGE_NAME}:${GIT_SHORT_SHA}"
    else
      SHORT_GIT_SHA_TAG="${IMAGE_NAME}:${SOURCE_IMAGE_TAG}-${GIT_SHORT_SHA}"
    fi
    tag_and_push_one ${SOURCE_IMAGE} ${SHORT_GIT_SHA_TAG}
  fi

  # 3: Tag with 'latest':
  if [ "${SOURCE_IMAGE_TAG}" == 'latest' ] && [ "${GIT_BRANCH}" == 'master' ]
  then
    LATEST_TAG="${IMAGE_NAME}:latest"
    tag_and_push_one ${SOURCE_IMAGE} ${LATEST_TAG}
  fi
}


case $GIVEN_COMMAND in
  download-cache)
    download_cache $2 $3
    ;;
  tag-and-push)
    tag_and_push $2 $3 $4
    ;;
  *)
    echo "Sorry, I don't understand"
    exit 1
    ;;
esac