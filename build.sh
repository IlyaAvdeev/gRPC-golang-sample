#!/bin/bash

# protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative ./def.proto
#protoc -I .  def.proto --go_out=plugins=grpc:.

version=1.0.1
image_name=ilyaavdeev/grpc-server-sample

sudo docker build -t $image_name:$version .
sudo docker tag $image_name:$version $image_name:latest
