#!/bin/bash -ex
domain=kevinchristen.duckdns.org
live_dir=/etc/letsencrypt/live/${domain}

if [[ $1 == init ]]; then
    sudo certbot certonly \
         --non-interactive \
         --agree-tos \
         --email kevin.christen@gmail.com \
         --preferred-challenges dns \
         --authenticator dns-duckdns \
         --dns-duckdns-credentials ~kevin/.certbot-dns-duckdns \
         --dns-duckdns-propagation-seconds 60 \
         -d ${domain}
elif [[ $1 == renew ]]; then
    sudo certbot renew \
         --cert-name ${domain} \
         --deploy-hook /etc/letsencrypt/renewal-hooks/deploy/deploy-plex-cert.sh
else
    >&2 echo "usage: $0 init | renew"
    exit 1
fi
