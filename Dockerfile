FROM alpine:3.9

RUN apk add --no-cache bash

COPY envInject.sh /init.sh

ENTRYPOINT ["/init.sh"]