#!/usr/bin/env bash
certs=/etc/docker/certs.d/127.0.0.1:5000
mkdir /registry-image
mkdir /etc/docker/certs
mkdir -p $certs
openssl req -x509 -config $(dirname "$0")/tls.csr -nodes -newkey rsa:4096 \
-keyout tls.key -out tls.crt -days 365 -extensions v3_req

cp tls.crt $certs
mv tls.* /etc/docker/certs

docker run -d \
  --restart=always \
  --name registry \
  -v /etc/docker/certs:/docker-in-certs:ro \
  -v /registry-image:/var/lib/registry \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/docker-in-certs/tls.crt \
  -e REGISTRY_HTTP_TLS_KEY=/docker-in-certs/tls.key \
  -p 5000:443 \
  registry:2
