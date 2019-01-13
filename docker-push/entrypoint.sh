#!/bin/sh

#
# a simple way to parse shell script arguments
#
# please edit and use to your hearts content
#

DOCKER_PUSH_IMAGE=$1
DOCKER_PUSH_LATEST="true"
DOCKER_PUSH_REF="true"
DOCKER_PUSH_SHA="true"

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

function push_latest()
{
  docker push ${DOCKER_PUSH_IMAGE}:latest || exit 1
}

function push_ref()
{
  tag=$(echo -n "${DOCKER_PUSH_REF_VALUE}" | sed -r 's/^refs\/heads\///' | sed -r 's/\//-/')
  docker push ${DOCKER_PUSH_IMAGE}:${tag} || exit 1
}

function push_sha()
{
  sha=$(echo -n "${DOCKER_PUSH_SHA_VALUE}" | cut -c1-7)
  docker push ${DOCKER_PUSH_IMAGE}:${sha} || exit 1
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
      DOCKER_PUSH_LATEST="false"
      ;;
    --no-ref)
      DOCKER_PUSH_REF="false"
      ;;
    --no-sha)
      DOCKER_PUSH_SHA="false"
      ;;
    # *)
    #     echo "ERROR: unknown parameter \"$PARAM\""
    #     usage
    #     exit 1
    #     ;;
  esac
  shift
done

DOCKER_PUSH_KNOWN_FLAGS="--no-latest --no-ref --no-sha"
DOCKER_PUSH_USAGE_ERRORS="false"

if [ -z "${DOCKER_PUSH_IMAGE}" ] || [ "${DOCKER_PUSH_KNOWN_FLAGS#*$DOCKER_PUSH_SOURCE_IMAGE}" != "$DOCKER_PUSH_KNOWN_FLAGS" ]
then
  echo "Error: No image given"
  DOCKER_PUSH_USAGE_ERRORS="true"
fi

DOCKER_PUSH_REF_VALUE=${GITHUB_REF:-${DRONE_COMMIT_REF}}
if [ "${DOCKER_PUSH_REF}" = "true" ] && [ -z "${DOCKER_PUSH_REF_VALUE}" ]
then
  echo "Error: Couldn't get a valid ref to generate the ref tag"
  DOCKER_PUSH_USAGE_ERRORS="true"
fi

DOCKER_PUSH_SHA_VALUE=${GITHUB_SHA:-${DRONE_COMMIT_SHA}}
if [ "${DOCKER_PUSH_SHA}" = "true" ] && [ -z "${DOCKER_PUSH_SHA_VALUE}" ]
then
  echo "Error: Couldn't get a valid SHA value to generate the SHA tag"
  DOCKER_PUSH_USAGE_ERRORS="true"
fi

if [ "${DOCKER_PUSH_USAGE_ERRORS}" = "true" ]
then
  display_usage
  exit 1
fi

if [ "${DOCKER_PUSH_SHA}" = "true" ]; then push_sha; fi
if [ "${DOCKER_PUSH_REF}" = "true" ]; then push_ref; fi
if [ "${DOCKER_PUSH_LATEST}" = "true" ]; then push_latest; fi
