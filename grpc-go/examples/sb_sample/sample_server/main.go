package main

import (
	"context"
	"log"
	"net"
	"math/rand"
	"github.com/golang/protobuf/jsonpb"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"bytes"

	"google.golang.org/grpc"
	pb "sb_sample/sample"
)

const (
	port = ":50051"
)

type server struct {
	pb.UnimplementedWizardServer
}

//http://www.inanzzz.com/index.php/post/yskn/handling-a-complex-json-request-within-a-grpc-client-and-server-golang-application
func (s *server) WhatIsAgeOf(ctx context.Context, in *pb.UserName) (*pb.UserInfo, error) {

	json := bytes.Buffer{}
	// OrigName uses the actual field names from the proto files rather than casting them to camelCase.
	// EmitDefaults prevents discarding empty/nullable fields and keeps zero values.
	mars := jsonpb.Marshaler{OrigName: true, EmitDefaults: true}
	if err := mars.Marshal(&json, in); err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "server: marshal: %v", err)
	}
	log.Println("REQUEST:", json.String())


	log.Printf("Received: %v", in.GetName())
	rand.NewSource(100)
	user_info := &pb.UserInfo {
		Message: in.GetName(),
		Age:   uint32(rand.Intn(100)),
	}
	
	return user_info, nil
}

func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterWizardServer(s, &server{})
	log.Printf("server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
