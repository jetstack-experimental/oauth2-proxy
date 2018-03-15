FROM alpine:3.7

RUN apk update && \
    apk add curl && \
    rm -rf /var/cache/apk/*

ENV OAUTH2_PROXY_HASH=1c16698ed0c85aa47aeb80e608f723835d9d1a8b98bd9ae36a514826b3acce56
RUN mkdir -p /tmp/oauth2-proxy && \
    curl -sL https://github.com/bitly/oauth2_proxy/releases/download/v2.2/oauth2_proxy-2.2.0.linux-amd64.go1.8.1.tar.gz > /tmp/oauth2-proxy/oauth2-proxy.tar.gz && \
    echo "${OAUTH2_PROXY_HASH}  /tmp/oauth2-proxy/oauth2-proxy.tar.gz" | sha256sum -c && \
    tar xvzf /tmp/oauth2-proxy/oauth2-proxy.tar.gz -C /tmp/oauth2-proxy --strip-components=1 && \
    mv /tmp/oauth2-proxy/oauth2_proxy /usr/local/bin/oauth2_proxy && \
    chown root:root /usr/local/bin/oauth2_proxy && \
    rm -rf /tmp/oauth2-proxy

EXPOSE 4180

ADD index.html /var/www/index.html

ENTRYPOINT ["/usr/local/bin/oauth2_proxy"]
CMD [ "--upstream=file:///var/www#/", "--http-address=0.0.0.0:4180" ]
