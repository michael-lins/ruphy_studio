#!/bin/bash

USERNAME="malvins"
IMAGE="ruphy-rails-dev"
VERSION_FIXED="8.0.2"
VERSION_FLEX="latest"

# Build fixed image
docker build --build-arg RAILS_VERSION=$VERSION_FIXED -t $USERNAME/$IMAGE:$VERSION_FIXED .

# Build floating (latest) image
docker build --build-arg RAILS_VERSION=$VERSION_FLEX -t $USERNAME/$IMAGE:$VERSION_FLEX .

# Push both to Docker Hub
docker push $USERNAME/$IMAGE:$VERSION_FIXED
docker push $USERNAME/$IMAGE:$VERSION_FLEX
