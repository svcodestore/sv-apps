FROM golang:1.17 AS API
WORKDIR /sv-sso-gin
COPY ./sv-sso-gin/ .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o http_server ./main.go && mkdir run && mv ./http_server ./config.yaml run
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o rpc_server ./rpc.go && mv ./rpc_server run

FROM nginx:1.21.6-alpine
ENV GIN_MODE=release
COPY ./sv-sso-antdp/dist/ /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d

COPY --from=API /sv-sso-gin/run ./
CMD ["sh", "-c", "nginx -c /etc/nginx/nginx.conf && ./http_server & \n ./rpc_server"]