#!/usr/bin/env bash

CONTAINER_ID=spotify-ripper
A=`docker inspect -f {{.State.Running}} ${CONTAINER_ID}`
echo "'$A' '$B' '$?'"
if [ "$A" = "true" ]; then
    echo "Docker $CONTAINER_ID is running, killing them..."
    docker kill ${CONTAINER_ID}
else
    echo "Docker $CONTAINER_ID not found."
fi
sleep 3
docker run -d \
            -e pass="$1" \
            -u `stat -c "%u:%g" ./songs/` \
            --name ${CONTAINER_ID} \
            -v $(pwd)/docker_config:/ripper/config \
            -v $(pwd)/songs:/ripper/songs \
            morgaroth/spotify-ripper:latest

echo "Docker fired! Now listening logs..."
docker logs -f ${CONTAINER_ID}