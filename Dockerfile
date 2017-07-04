FROM alpine
MAINTAINER James Eckersall <james.eckersall@gmail.com>

ENV CONSUL_VERSION    0.8.5
ENV CONSUL_HTTP_PORT  8500
ENV CONSUL_HTTPS_PORT 8543
ENV CONSUL_DNS_PORT   53

RUN \
  apk --update add openssl zip curl ca-certificates jq && \
  cat /etc/ssl/certs/*.pem > /etc/ssl/certs/ca-certificates.crt && \
  sed -i -r '/^#.+/d' /etc/ssl/certs/ca-certificates.crt && \
  rm -rf /var/cache/apk/* && \
  mkdir -m 0775 -p /etc/consul/ssl /ui /data && \
  wget http://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
  unzip consul_${CONSUL_VERSION}_linux_amd64.zip && \
  mv consul /bin/ && \
  rm -f consul_${CONSUL_VERSION}_linux_amd64.zip && \
  cd /ui && \
  wget http://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip && \
  unzip consul_${CONSUL_VERSION}_web_ui.zip && \
  rm -f consul_${CONSUL_VERSION}_linux_amd64.zip

COPY config.json /etc/consul/config.json
COPY run.sh /usr/bin/run.sh

RUN \
  chmod +x /usr/bin/run.sh && \
  chmod -R 0775 /etc/consul

EXPOSE ${CONSUL_HTTP_PORT}
EXPOSE ${CONSUL_HTTPS_PORT}
EXPOSE ${CONSUL_DNS_PORT}

ENTRYPOINT ["/usr/bin/run.sh"]
CMD []
