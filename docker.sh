#!/bin/bash

set -e
echo "enter image name"
read imgName
echo "enter image tag"
read imgTag
echo "enter image sha"
read imgSha

img=$imgName:$imgTag@$imgSha

#pull image
echo "==> PULLING IMAGE"
docker pull $img > /dev/null 


#specify subnet to push image
echo -e "push to: \n 1- qpn prod \n 2- qpn dev \n PLEASE ENTER 1 or 2"
read subnet
echo "==> UPDATING DNS"
if [ $subnet -eq 1 ]
then
	hostname="AQ1NML-P-OS-REG"
	#echo "10.20.50.53	$hostname" >> /etc/hosts
	ip="10.20.50.53"
elif [ $subnet -eq 2 ]
then
	hostname="AQ1NML-D-OS-REG.qpn.local"
	#echo "10.20.49.46       $hostname" >> /etc/hosts
	ip="10.20.49.46"
#elif [ $subnet -eq 3 ]
#then
#	hostname="AS1NML-P-OS-BST.pcls.ssn.local"
#	#echo "10.20.54.42       $hostname" >> /etc/hosts
#	ip="10.20.54.42"
#elif [ $subnet -eq 4 ]
#then
#	hostname="AS1NML-D-OS-BST.dcls.ssn.local"
	#echo "10.20.53.29       $hostname" >> /etc/hosts
#	ip="10.20.53.29"
#fi

dnsRecord="$ip	$hostname"
#if ! grep -Fxq "$dnsRecord" /etc/hosts
#then
    # If the string does not exist, write it to the file
 #   echo "$dnsRecord" >> /etc/hosts
#fi

#echo "==> UPDATING daemon.json FILE"
#rm -f /etc/docker/daemon.json
#echo '{ "insecure-registries" : [ "'$hostname':5007" ] }' > /etc/docker/daemon.json
#systemctl restart docker.service

#login to docker registry
echo " ==> LOGIN TO DOCKER REGISTRY"
docker login --username=acud --password=password $hostname:5007 

#image tag
echo "==>TAGING IMAGE"
imgname=$(echo $imgName | sed "s/docker\.io\///g")
imgId=$(docker images -q $imgname | head -n 1)

docker tag $imgId $hostname:5007/$imgname:$imgTag > /dev/null

#push image
echo "==> PUSHING IMAGE"
docker push $hostname:5007/$imgname:$imgTag

echo "==> DONE <=="
