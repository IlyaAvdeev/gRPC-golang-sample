#!/bin/bash

readarray -t version < ./version
image_name=ilyaavdeev/grpc-server-client-sample

sudo docker run --name=rom_cola --tty --rm --env PARAM="$1" --net=my-net $image_name:$version
