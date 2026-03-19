FROM alpine:3.20

RUN apk add --no-cache bash curl jq

COPY images/tools/scripts/ /opt/tools/

RUN chmod 0755 /opt/tools/*.sh

ENTRYPOINT ["/opt/tools/export-realm.sh"]
