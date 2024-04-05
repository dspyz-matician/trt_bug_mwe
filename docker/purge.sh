# Set the name of the Docker container and image
CONTAINER_NAME="trt_mwe"
IMAGE_NAME="trt_mwe_image"

# Remove the container (if it exists)
echo "Removing container (if exists)..."
docker rm -f $CONTAINER_NAME || true

# Remove the image (if it exists)
echo "Removing image (if exists)..."
docker rmi -f $IMAGE_NAME || true
