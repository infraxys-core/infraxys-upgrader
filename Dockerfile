FROM alpine:3.11

RUN apk update \
  && apk upgrade \
  && apk add bash \
  && apk add mariadb-client \
  && apk add openrc docker \
  && apk add py-pip \
  && apk add python-dev libffi-dev openssl-dev gcc libc-dev make \
  && pip install docker-compose


COPY entrypoint.sh /entrypoint.sh
COPY sql/ sql/
COPY bash/ bash/
ENTRYPOINT [ "/entrypoint.sh" ]
