#!/usr/bin/env bash

CONTAINER_ID=spotify-ripper
A=`docker inspect -f {{.State.Running}} ${CONTAINER_ID}`
echo "'$A' '$B' '$?'"
if [ "$A" = "false" ]; then
    echo "Docker $CONTAINER_ID isn't running, exiting..."
#    docker run -it --entrypoint=zsh
else
    echo "Docker $CONTAINER_ID runs."
    docker exec -it ${CONTAINER_ID} /bin/zsh
fi
