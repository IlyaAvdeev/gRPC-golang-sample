package main

import (
	"context"
	"log"
	"net"
	//"math/rand"

	"google.golang.org/grpc"
	pb "sb_sample/sample"
)

const (
	port = ":50051"
)

type server struct {
	pb.UnimplementedWizardServer
}

func (s *server) WhatIsAgeOf(ctx context.Context, in *pb.UserName) (*pb.UserInfo, error) {
	log.Printf("Received: %v", in.GetName())
	//return &pb.WhatIsAgeOf{Message: "Hello " + in.GetName(), Age: rand.Intn(10)}
	
	user_info := &pb.UserInfo {
		Message: in.GetName(),
		Age:   35,
	}
	return user_info, nil
}

//func (s *server) SayHelloAgain(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
//        return &pb.HelloReply{Message: "Hello again " + in.GetName()}, nil
//}

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
