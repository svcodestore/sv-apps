FROM golang:1.17 AS API
WORKDIR /sv-sso-gin
COPY ./sv-sso-gin/ .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o server ./main.go && mkdir run && mv ./server ./config.yaml run

FROM nginx:1.21.6-alpine
ENV GIN_MODE=release
COPY ./sv-sso-antdp/dist/ /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/community' >>/etc/apk/repositories && \
    apk add --no-cache ca-certificates && update-ca-certificates

COPY --from=API /sv-sso-gin/run ./
CMD ["sh", "-c", "nginx -c /etc/nginx/nginx.conf && ./server"]