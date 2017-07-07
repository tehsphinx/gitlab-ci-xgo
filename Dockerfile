FROM golang:1.8

RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.03.1-ce.tgz && \
tar --strip-components=1 -xvzf docker-17.03.1-ce.tgz -C /usr/local/bin

RUN chown -R daemon:daemon /var/run/docker.sock

CMD ["/bin/sh"]