#!/bin/bash

readarray -t version < ./version
image_name=ilyaavdeev/grpc-server-sample
docker push $image_name:$version

client_image_name=ilyaavdeev/grpc-server-client-sample
docker push $client_image_name:$version
