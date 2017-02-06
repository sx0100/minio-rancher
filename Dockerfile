FROM rawmind/alpine-monit:0.5.20-4
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

ENV SERVICE_NAME=minio \
    SERVICE_HOME=/opt/minio \
    SERVICE_VERSION=RELEASE.2017-01-25T03-14-52Z \
    SERVICE_CONF=/opt/minio/conf/minio-server.cfg \
    SERVICE_USER=minio \
    SERVICE_UID=10003 \
    SERVICE_GROUP=minio \
    SERVICE_GID=10003 \
    SERVICE_VOLUME=/opt/tools \
    PATH=/opt/minio/bin:${PATH}

# Install service software
RUN apk update && apk add openrc glibc &&\
    mkdir -p ${SERVICE_HOME}/logs ${SERVICE_HOME}/data ${SERVICE_HOME}/bin ${SERVICE_HOME}/conf && \
    addgroup -g ${SERVICE_GID} ${SERVICE_GROUP} && \
    adduser -g "${SERVICE_NAME} user" -D -h ${SERVICE_HOME} -G ${SERVICE_GROUP} -s /sbin/nologin -u ${SERVICE_UID} ${SERVICE_USER}

ADD https://dl.minio.io/server/minio/release/linux-amd64/archive/minio.${SERVICE_VERSION} ${SERVICE_HOME}/bin/minio

ADD root /
RUN chmod +x ${SERVICE_HOME}/bin/* \
  && chown -R ${SERVICE_USER}:${SERVICE_GROUP} ${SERVICE_HOME} /opt/monit

USER $SERVICE_USER
WORKDIR $SERVICE_HOME
VOLUME ${SERVICE_HOME}/data

EXPOSE 9000
