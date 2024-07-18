#!/bin/bash

# Get the current date
current_date=$(date +"%m.%d.%Y")

# Define the image name and tag
IMAGE_NAME="dev-environment"
#IMAGE_TAG="latest"
NO_CACHE="--no-cache"
IMAGE_TAG=$current_date
IMAGE_VER_TAG="a"
GOLANG_VERSION=1.22.3
DOTNET_SDK_VERSION=7.0
PYTHON_VERSION=3.11
TERRAFORM_VERSION=1.8.4

# Navigate to the directory containing the Dockerfile
# Uncomment the next line if your Dockerfile is in a specific directory
# cd path/to/dockerfile

# Build the image with the defined name and tag
# docker build --build-arg GOGLAN_VERSION=1.22.3 --build-arg DOTNET_SDK_VERSION=7.0 --build-arg PYTHON_VERSION=3.12 --no-cache --platform linux/amd64 -t ${IMAGE_NAME}:${IMAGE_TAG} .
docker build \
  --build-arg GOGLAN_VERSION=${GOGLAN_VERSION} \
  --build-arg DOTNET_SDK_VERSION=${DOTNET_SDK_VERSION} \
  --build-arg PYTHON_VERSION=${PYTHON_VERSION} \
  ${NO_CACHE} --platform linux/amd64 \
  -t ${IMAGE_NAME}:${IMAGE_TAG}${IMAGE_VER_TAG} .

# Build the image with the defined name and tag
# docker build ${NO_CACHE} ${PLATFORM:-"--platform linux/amd64"} \
#   --build-arg GOLANG_VERSION=${GOLANG_VERSION} \
#   --build-arg DOTNET_SDK_VERSION=${DOTNET_SDK_VERSION} \
#   --build-arg PYTHON_VERSION=${PYTHON_VERSION} \
#   --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
#   -t ${IMAGE_NAME}:${IMAGE_TAG} .

# Check if the image was built successfully
if [ $? -eq 0 ]; then
    echo "Docker image built successfully."
    echo "Image name: ${IMAGE_NAME}"
    echo "Tag: ${IMAGE_TAG}"
else
    echo "Failed to build Docker image."
    exit 1
fi
