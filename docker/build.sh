#!/bin/bash

# Set the name of the Docker container and image
CONTAINER_NAME="trt_mwe"
IMAGE_NAME="trt_mwe_image"

# Remove the old container (if it exists)
echo "Removing old container (if exists)..."
docker rm -f $CONTAINER_NAME || true

# Get the ID of the old image (if it exists)
OLD_IMAGE_ID=$(docker images --format "{{.ID}}" --filter "reference=$IMAGE_NAME" | head -1)

# Build the image from the Dockerfile
echo "Building image from Dockerfile..."
docker build -t $IMAGE_NAME .

# Check if a new image was built (indicating changes to the Dockerfile)
NEW_IMAGE_ID=$(docker images --format "{{.ID}}" --filter "reference=$IMAGE_NAME" | head -1)

if [ "$NEW_IMAGE_ID" != "$OLD_IMAGE_ID" ]; then
    # Remove the old image (if it exists and is different from the new image)
    if [ -n "$OLD_IMAGE_ID" ]; then
        echo "Removing old image with ID: $OLD_IMAGE_ID"
        docker rmi $OLD_IMAGE_ID
    fi
else
    echo "No changes to the Dockerfile. Skipping removal of the old image."
fi

echo "Script completed successfully!"
