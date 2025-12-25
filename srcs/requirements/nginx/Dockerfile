FROM alpine:3.22

RUN apk update && apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=aohssine.42.fr/UID=aohssine"

RUN mkdir -p /var/run/nginx

# Place config into the standard `conf.d` directory so nginx includes it
COPY conf/nginx.conf /etc/nginx/http.d/a.conf

# Fix typo: "daemon" spelled correctly and keep nginx in foreground
CMD ["nginx","-g","daemon off;"]
