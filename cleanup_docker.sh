#!/bin/bash

# Remove stopped containers
docker container prune -f

# Remove unused volumes
docker volume prune -f

# Remove dangling images
docker image prune -f
