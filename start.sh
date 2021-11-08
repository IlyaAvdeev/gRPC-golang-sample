#!/bin/bash

readarray -t version < ./version
image_name=ilyaavdeev/grpc-server-sample

sudo docker run --tty --rm -p 8080:50051 $image_name:$version
