#!/bin/bash

readarray -t version < ./version
image_name=ilyaavdeev/grpc-server-sample

sudo docker build --no-cache -t $image_name:$version .
sudo docker tag $image_name:$version $image_name:latest

client_image_name=ilyaavdeev/grpc-server-client-sample
sudo docker build  --no-cache --file Dockerfile_client -t $client_image_name:$version .
sudo docker tag $client_image_name:$version $client_image_name:latest
