FROM bash:5.0.2

COPY envInject.sh /init.sh

ENTRYPOINT ["/init.sh"]