**Task1:**
Pulling Images from private repos on github and Pushing it to Local Repository
Solution 1: (Manual)
Step1
#Create the Local repo 'acud-local-repo' using docker we create a container based on the registry v2 image and we mount it to a persistent volume and use the port 5001
$mkdir /var/lib/registry
$ls /auth
$ls /certs/domain.key
$docker run -d --restart=always --name acud-tncp-images-qpn-registry \
  -v /opt/certs/:/certs \
  -v /opt/docker-storage:/var/lib/registry \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:5007 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  -p 5000:5007 \
  -v /opt/docker-auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/registry.password \
  registry:2
