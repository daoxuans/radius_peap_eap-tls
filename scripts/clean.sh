#!/usr/bin/env sh

DOCKERCOMPOSEFILE=${PWD}/docker-compose.yml
if [ ! -f "${DOCKERCOMPOSEFILE}" ]; then
    /usr/bin/printf "Run from directory where docker-compose.yml resides.\n\n"
    exit 1
fi

/usr/bin/printf "WARNING WARNING WARNING WARNING WARNING\n"
/usr/bin/printf "This will remove all your configuration data,\n"
/usr/bin/printf "including your Certificate Authority!\n"
/usr/bin/printf "Are you sure (y|n)? "
read -r ANSWER

# The '#' performs substring removal
# See bash string manipulation
if [ "${ANSWER}" != "${ANSWER#[Yy]}" ] ;then
    /usr/local/bin/docker-compose down --rmi all -v
    /bin/rm -rf ./backup/*
    /bin/rm -rf ./provision/*
    # /usr/bin/docker volume rm radius_peap_eap-tls_raddb

    # Remove all unused networks
    /usr/bin/docker network prune -f

    # Remove all unused volumes
    /usr/bin/docker volume prune -f

    # Remove all dangling (untagged) images
    /usr/bin/docker image prune -f

    # Optionally, remove all unused build cache
    /usr/bin/docker builder prune -a -f
fi
