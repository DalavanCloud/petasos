FROM golang:alpine as builder
MAINTAINER Jack Murdock <jack_murdock@comcast.com>

# build the binary
WORKDIR /go/src
RUN apk add --update --repository https://dl-3.alpinelinux.org/alpine/edge/testing/ git curl
RUN curl https://glide.sh/get | sh
COPY src/ /go/src/

RUN glide -q install --strip-vendor
RUN go build -o petasos_linux_amd64 petasos

EXPOSE 6400 6401 6402 6403
RUN mkdir -p /etc/petasos
VOLUME /etc/petasos

# the actual image
FROM alpine:latest
RUN apk --no-cache add ca-certificates
RUN mkdir -p /etc/petasos
VOLUME /etc/petasos
WORKDIR /root/
COPY --from=builder /go/src/petasos_linux_amd64 .
ENTRYPOINT ["./petasos_linux_amd64"]
