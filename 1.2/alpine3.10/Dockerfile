
FROM python:2.7.17-alpine3.10

ARG TRAC_VERSION=1.2.5
ENV TRAC_PARENT_DIR=/trac/

EXPOSE 80

WORKDIR /trac

VOLUME /trac

COPY docker-entrypoint /usr/local/bin/docker-entrypoint
COPY docker-initenv /usr/local/bin/docker-initenv

RUN pip install trac=="$TRAC_VERSION"

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]

CMD ["--port=80", "--env-parent-dir=/trac"]
