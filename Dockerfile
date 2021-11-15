FROM golang:1.17.2

RUN apt-get update && apt-get install -y zip

RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.15.8/protoc-3.15.8-linux-x86_64.zip && unzip protoc-3.15.8-linux-x86_64.zip -d $HOME/.local
RUN rm protoc-3.15.8-linux-x86_64.zip

ENV PATH="${HOME}/.local/bin:${PATH}"
ENV GO111MODULE=on
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26 && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1
ENV PATH="$(go env GOPATH)/bin:${PATH}"

RUN mkdir /app
WORKDIR /app
COPY ./grpc-go .

RUN $HOME/.local/bin/protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative --proto_path=/app/examples/sb_sample\
    sample/sample.proto
RUN go mod download

#without next 2 lines when running the app you get 
# examples/helloworld/greeter_server/main.go:28:2: no required module provides package google.golang.org/grpc/examples/helloworld/helloworld; to add it:
#    go get google.golang.org/grpc/examples/helloworld/helloworld
RUN mkdir -p /usr/local/go/src/sb_sample/sample
RUN cp /app/examples/sb_sample/sample/*.go /usr/local/go/src/sb_sample/sample

EXPOSE 50051

ENTRYPOINT ["go", "run", "examples/sb_sample/sample_server/main.go"]