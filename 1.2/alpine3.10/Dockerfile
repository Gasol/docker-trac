# vim: set ft=dockerfile:

FROM python:2.7.17-alpine3.10

ENV ALPINE_VERSION=3.10
ENV TRAC_VERSION=1.2.5
ENV TRAC_URL=https://files.pythonhosted.org/packages/4c/26/2a30c12da0d27fa69b54e2429fa39805922f6d89e0709061d1d43d34b9ba/Trac-1.2.5-py2-none-any.whl
ENV TRAC_URL_FILENAME=Trac-1.2.5-py2-none-any.whl
ENV TRAC_SHA256=1ee48558362b6ffc2963b4c24c33b971582f996cf0f33e22ec7b4f63be75b19e
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

