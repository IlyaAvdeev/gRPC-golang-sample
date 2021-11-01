FROM golang:1.17.2

RUN apt-get update && apt-get install -y zip

RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.15.8/protoc-3.15.8-linux-x86_64.zip
RUN unzip protoc-3.15.8-linux-x86_64.zip -d $HOME/.local
RUN echo $HOME
ENV PATH="${HOME}/.local/bin:${PATH}"
ENV GO111MODULE=auto
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1
ENV PATH="$(go env GOPATH)/bin:${PATH}"

RUN go version

RUN mkdir /app
WORKDIR /app
COPY ./grpc-go .
RUN go mod download

RUN go get google.golang.org/grpc/examples/helloworld/helloworld

EXPOSE 50051

CMD ["go", "run", "./examples/helloworld/greeter_server/main.go"]



