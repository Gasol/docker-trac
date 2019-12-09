# vim: set ft=dockerfile:

FROM python:2.7.17-alpine3.10

ENV ALPINE_VERSION=3.10
ENV TRAC_VERSION=1.4
ENV TRAC_URL=https://files.pythonhosted.org/packages/16/96/4f0485d5be269289b19fb46da466a1fb1d47843d60b2c3f7151c3d04a20c/Trac-1.4-py2-none-any.whl
ENV TRAC_URL_FILENAME=Trac-1.4-py2-none-any.whl
ENV TRAC_SHA256=4e2a312c7726eee302bb63b4f70cd43d5fa5f0a5eae253f05fef00a8f844b83c
ENV TRAC_PARENT_DIR=/trac/

EXPOSE 80

WORKDIR /trac
VOLUME /trac

COPY docker-entrypoint /usr/local/bin/docker-entrypoint
COPY docker-initenv /usr/local/bin/docker-initenv

RUN (set -eux -o pipefail; cd /tmp; \
      wget -O "$TRAC_URL_FILENAME" "$TRAC_URL"; \
      echo "$TRAC_SHA256  $TRAC_URL_FILENAME" | sha256sum -c -; \
      pip install "$TRAC_URL_FILENAME"; \
      rm "$TRAC_URL_FILENAME")

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]

CMD ["--port=80", "--env-parent-dir=/trac"]

