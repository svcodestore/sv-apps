FROM golang:1.17 AS API
WORKDIR /sv-im-gin
COPY ./sv-im-gin/ .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o http_server ./main.go && mkdir run && mv ./http_server ./config.yaml run

FROM nginx:1.21.6-alpine
ENV GIN_MODE=release
COPY ./sv-im-vben/dist/ /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d

COPY --from=API /sv-im-gin/run ./
CMD ["sh", "-c", "nginx -c /etc/nginx/nginx.conf && ./http_server"]