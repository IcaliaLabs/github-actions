#!/bin/sh

GIVEN_COMMAND=$1

function download_cache()
{
  COMPOSE_FILE=$1
  SERVICE_NAME=$2

  for image_name in $(docker-compose --file ${COMPOSE_FILE} config | yq -t r - services.${SERVICE_NAME}.build.cache_from)
  do
    if [ "${image_name}" == "-" ]; then continue; fi
    echo "====${image_name}===="
    docker pull ${image_name} || echo "cache miss"
  done
}


case $GIVEN_COMMAND in
	download-cache)
		download_cache $2 $3
		;;
	*)
		echo "Sorry, I don't understand"
    exit 1
		;;
esac