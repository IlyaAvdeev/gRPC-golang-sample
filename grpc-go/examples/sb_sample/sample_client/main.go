package main

import (
	"context"
	"log"
	"os"
	"time"

	"google.golang.org/grpc"
	pb "sb_sample/sample"
)

const (
	address     = "banana_mama:50051"
	defaultName = "Ilya"
)

func main() {
	// Set up a connection to the server.
	conn, err := grpc.Dial(address, grpc.WithInsecure(), grpc.WithBlock())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewWizardClient(conn)

	// Contact the server and print out its response.
	name := defaultName
	if len(os.Args) > 1 {
		name = os.Args[1]
	}
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	r, err := c.WhatIsAgeOf(ctx, &pb.UserName{Name: name})
	if err != nil {
		log.Fatalf("Error occured: %v", err)
	}
	log.Printf("Response: %s is %d years old", r.GetMessage(), r.GetAge())
}
