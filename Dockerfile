FROM golang:1.17.2

RUN apt-get update && apt-get install -y zip

RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.15.8/protoc-3.15.8-linux-x86_64.zip
RUN unzip protoc-3.15.8-linux-x86_64.zip -d $HOME/.local
RUN echo $HOME
ENV PATH="${HOME}/.local/bin:${PATH}"
ENV GO111MODULE=on
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1
ENV PATH="$(go env GOPATH)/bin:${PATH}"

RUN mkdir /app
WORKDIR /app
COPY ./grpc-go .

RUN $HOME/.local/bin/protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative --proto_path=/app/examples/helloworld\
    helloworld/helloworld.proto
RUN go mod download

RUN mkdir -p /usr/local/go/src/helloworld/helloworld
RUN cp /app/examples/helloworld/helloworld/*.go /usr/local/go/src/helloworld/helloworld

RUN ls /usr/local/go/src/helloworld/helloworld
#RUN go get google.golang.org/grpc/examples/helloworld/helloworld
EXPOSE 50051

ENTRYPOINT ["go", "run", "examples/helloworld/greeter_server/main.go"]



