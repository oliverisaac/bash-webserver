FROM ubuntu

ADD ./scripts /scripts

RUN /bin/bash /scripts/setup

ADD ./server /server

EXPOSE 80

ENTRYPOINT [ "/server/serve" ]

