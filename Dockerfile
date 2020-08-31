FROM ubuntu

ADD ./scripts /scripts

RUN /bin/bash /scripts/setup

ADD ./www /var/www
ADD ./server /server

EXPOSE 80

ENTRYPOINT [ "/server/serve" ]

