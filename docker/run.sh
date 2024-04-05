#!/bin/bash

# Set the name of the Docker container and image
CONTAINER_NAME="trt_mwe"
IMAGE_NAME="trt_mwe_image"

# Check if a container with the same name exists and is stopped
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    # Remove the existing container
    echo "Removing existing container: $CONTAINER_NAME"
    docker rm -f $CONTAINER_NAME
fi

# Run a new container with the specified options and container name
echo "Running a new container: $CONTAINER_NAME"
docker run --name $CONTAINER_NAME \
    -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --mount type=bind,source=$(cd $(dirname $(dirname $0)) && pwd),destination=/home/me/app \
    --mount type=bind,source=$HOME/.bash_history,destination=/home/me/.bash_history \
    --user $(id -u):$(id -g) \
    --gpus all \
    -itd $IMAGE_NAME:latest /bin/bash

echo "Copying configuration files and credentials to the container..."

if [ -f "$HOME/.gitconfig" ]; then
    docker cp $HOME/.gitconfig $CONTAINER_NAME:/home/me/.gitconfig
fi

if [ -d "$HOME/.ssh" ]; then
    docker cp $HOME/.ssh $CONTAINER_NAME:/home/me/.ssh
fi

docker exec $CONTAINER_NAME bash -c "git config --global --add safe.directory /home/me/app"

# Check if the -d flag is provided
if [ "$1" != "-d" ]; then
    docker attach $CONTAINER_NAME
fi
