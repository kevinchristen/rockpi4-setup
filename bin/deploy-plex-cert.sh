#!/bin/bash -ex

for domain in ${RENEWED_DOMAINS}; do
    pkcs12_file=${RENEWED_LINEAGE}/${domain}.pfx

    sudo openssl pkcs12 -export -in ${RENEWED_LINEAGE}/fullchain.pem -inkey ${RENEWED_LINEAGE}/privkey.pem -out ${pkcs12_file} -password file:/etc/letsencrypt/${domain}.pkcs12.password

    # UID and GID of the plex media server process
    sudo chown 1000:1000 ${pkcs12_file}
done

sudo docker-compose -f ~kevin/rockpi4-setup/docker/plex-docker.yaml restart
