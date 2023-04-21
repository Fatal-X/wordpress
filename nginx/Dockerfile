FROM nginx:alpine
RUN apk update && \
    apk --no-cache add shadow && \
    usermod -u 1001 nginx && \
    usermod -G www-data nginx && \
    apk del shadow
COPY configs/nginx.conf /etc/nginx/nginx.conf
COPY configs/conf.d/server.conf /etc/nginx/conf.d/
COPY ssl/server.crt /etc/nginx/ssl/server.cert
COPY ssl/server.key /etc/nginx/ssl/server.key
RUN chown -R nginx /etc/nginx/ssl/server.*
RUN chmod 400 /etc/nginx/ssl/server.*
