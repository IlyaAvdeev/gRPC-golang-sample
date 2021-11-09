#!/bin/bash

readarray -t version < ./version
image_name=ilyaavdeev/grpc-server-sample

sudo docker run --name=banana_mama --net=my-net --tty --rm -p 8080:50051 $image_name:$version
