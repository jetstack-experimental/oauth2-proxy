FROM alpine:3.7

RUN apk update && \
    apk add curl && \
    rm -rf /var/cache/apk/*

ENV OAUTH2_PROXY_HASH=3061e5b04bd14eeb9ec0ad1c9b324ba8d99d50eaadc5f528cdf4d21043828298
RUN mkdir -p /tmp/oauth2-proxy && \
    curl -sL https://github.com/bitly/oauth2_proxy/releases/download/v2.1/oauth2_proxy-2.1.linux-amd64.go1.6.tar.gz > /tmp/oauth2-proxy/oauth2-proxy.tar.gz && \
    echo "${OAUTH2_PROXY_HASH}  /tmp/oauth2-proxy/oauth2-proxy.tar.gz" | sha256sum -c && \
    tar xvzf /tmp/oauth2-proxy/oauth2-proxy.tar.gz -C /tmp/oauth2-proxy --strip-components=1 && \
    mv /tmp/oauth2-proxy/oauth2_proxy /usr/local/bin/oauth2_proxy && \
    chown root:root /usr/local/bin/oauth2_proxy && \
    rm -rf /tmp/oauth2-proxy

EXPOSE 4180

ENTRYPOINT ["/usr/local/bin/oauth2_proxy"]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
