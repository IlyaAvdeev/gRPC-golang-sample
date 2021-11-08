#!/bin/bash

# protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative ./def.proto
#protoc -I .  def.proto --go_out=plugins=grpc:.

readarray -t version < ./version
image_name=ilyaavdeev/grpc-server-sample

sudo docker push $image_name:$version
