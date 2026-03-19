FROM alpine:3.20

RUN apk add --no-cache bash curl jq

COPY images/provisioning/scripts/ /opt/provisioning/

RUN chmod 0755 /opt/provisioning/*.sh

ENTRYPOINT ["/opt/provisioning/sync-users.sh"]
