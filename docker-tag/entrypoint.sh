#!/bin/sh

#
# a simple way to parse shell script arguments
#
# please edit and use to your hearts content
#

DOCKER_TAG_SOURCE_IMAGE=$1
DOCKER_TAG_TARGET_IMAGE=$2
DOCKER_TAG_LATEST="true"
DOCKER_TAG_REF="true"
DOCKER_TAG_SHA="true"

function display_usage()
{
    echo "if this was a real script you would see something useful here"
    echo ""
    echo "./simple_args_parsing.sh"
    echo "\t-h --help"
    echo "\t--environment=$ENVIRONMENT"
    echo "\t--db-path=$DB_PATH"
    echo ""
}

function tag_latest()
{
  docker tag ${DOCKER_TAG_SOURCE_IMAGE} ${DOCKER_TAG_TARGET_IMAGE}:latest \
  && echo "Tagged ${DOCKER_TAG_SOURCE_IMAGE} as ${DOCKER_TAG_TARGET_IMAGE}:latest" \
  || exit 1
}

function tag_ref()
{
  tag=$(echo -n "${DOCKER_TAG_REF_VALUE}" | sed -r 's/^refs\/heads\///')
  docker tag ${DOCKER_TAG_SOURCE_IMAGE} ${DOCKER_TAG_TARGET_IMAGE}:${tag} \
  && echo "Tagged ${DOCKER_TAG_SOURCE_IMAGE} as ${DOCKER_TAG_TARGET_IMAGE}:${tag}" \
  || exit 1
}

function tag_sha()
{
  sha=$(echo -n "${DOCKER_TAG_SHA_VALUE}" | cut -c1-7)
  docker tag ${DOCKER_TAG_SOURCE_IMAGE} ${DOCKER_TAG_TARGET_IMAGE}:${sha} \
  && echo "Tagged ${DOCKER_TAG_SOURCE_IMAGE} as ${DOCKER_TAG_TARGET_IMAGE}:${sha}" \
  || exit 1
}

while [ "$1" != "" ]; do
  PARAM=`echo $1 | awk -F= '{print $1}'`
  VALUE=`echo $1 | awk -F= '{print $2}'`
  case $PARAM in
    -h | --help)
      display_usage
      exit
      ;;
    --no-latest)
      DOCKER_TAG_LATEST="false"
      ;;
    --no-ref)
      DOCKER_TAG_REF="false"
      ;;
    --no-sha)
      DOCKER_TAG_SHA="false"
      ;;
    # *)
    #     echo "ERROR: unknown parameter \"$PARAM\""
    #     usage
    #     exit 1
    #     ;;
  esac
  shift
done

DOCKER_TAG_KNOWN_FLAGS="--no-latest --no-ref --no-sha"
DOCKER_TAG_USAGE_ERRORS="false"

if [ -z "${DOCKER_TAG_SOURCE_IMAGE}" ] || [ "${DOCKER_TAG_KNOWN_FLAGS#*$DOCKER_TAG_SOURCE_IMAGE}" != "$DOCKER_TAG_KNOWN_FLAGS" ]
then
  echo "Error: No source image given"
  DOCKER_TAG_USAGE_ERRORS="true"
fi

if [ -z "${DOCKER_TAG_TARGET_IMAGE}" ] || [ "${DOCKER_TAG_KNOWN_FLAGS#*$DOCKER_TAG_TARGET_IMAGE}" != "$DOCKER_TAG_KNOWN_FLAGS" ]
then
  echo "Error: No target image given"
  DOCKER_TAG_USAGE_ERRORS="true"
fi

DOCKER_TAG_REF_VALUE=${GITHUB_REF:-${DRONE_COMMIT_REF}}
if [ "${DOCKER_TAG_REF}" = "true" ] && [ -z "${DOCKER_TAG_REF_VALUE}" ]
then
  echo "Error: Couldn't get a valid ref to generate the ref tag"
  DOCKER_TAG_USAGE_ERRORS="true"
fi

DOCKER_TAG_SHA_VALUE=${GITHUB_SHA:-${DRONE_COMMIT_SHA}}
if [ "${DOCKER_TAG_SHA}" = "true" ] && [ -z "${DOCKER_TAG_SHA_VALUE}" ]
then
  echo "Error: Couldn't get a valid SHA value to generate the SHA tag"
  DOCKER_TAG_USAGE_ERRORS="true"
fi

if [ "${DOCKER_TAG_USAGE_ERRORS}" = "true" ]
then
  display_usage
  exit 1
fi

if [ "${DOCKER_TAG_LATEST}" = "true" ]; then tag_latest; fi
if [ "${DOCKER_TAG_REF}" = "true" ]; then tag_ref; fi
if [ "${DOCKER_TAG_SHA}" = "true" ]; then tag_sha; fi
