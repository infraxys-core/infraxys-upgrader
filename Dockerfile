FROM alpine:3.13

RUN apk update \
  && apk upgrade \
  && apk add bash \
  && apk add mariadb-client \
  && apk add openrc docker \
  && apk add libffi-dev openssl-dev gcc libc-dev make

#RUN apk add py-pip \
#  && apk add python-dev libffi-dev openssl-dev gcc libc-dev make
RUN apk add python3
RUN apk add py3-pip
RUN  apk add python3-dev
RUN pip3 install setuptools_rust docker-compose


COPY entrypoint.sh /entrypoint.sh
COPY sql/ sql/
COPY bash/ bash/
ENTRYPOINT [ "/entrypoint.sh" ]