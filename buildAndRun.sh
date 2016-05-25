#!/usr/bin/env bash

CONTAINER_ID=spotify-ripper
A=`docker inspect -f {{.State.Running}} ${CONTAINER_ID}`
B=`docker inspect -f {{.State.Dead}} ${CONTAINER_ID}`
echo "'$A' '$B' '$?'"
if [ "$A" = "true" ]; then
    echo "Docker $CONTAINER_ID is running, killing them..."
    docker kill ${CONTAINER_ID}
else
    echo "Docker $CONTAINER_ID not found."
fi
sleep 3
if [ "$B" != "true" ]; then
    echo "Docker $CONTAINER_ID image exists, removing them..."
    docker rm ${CONTAINER_ID}
else
    echo "Docker image $CONTAINER_ID not found."
fi
sleep 1

rm -rf dist
mkdir dist
cp -r Dockerfile requirements.txt spotify_ripper/ setup.py README.rst dist/

cd dist
docker build -t morgaroth/spotify-ripper .
cd ..
docker run \
            -d \
            -u `stat -c "%u:%g" ./songs/` \
            -e pass="$1" \
            --name ${CONTAINER_ID} \
            -v $(pwd)/docker_config:/ripper/config \
            -v $(pwd)/songs:/ripper/songs \
            morgaroth/spotify-ripper:latest

echo "Docker fired! Now listening logs..."
docker logs -f ${CONTAINER_ID}