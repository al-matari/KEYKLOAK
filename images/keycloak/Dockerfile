ARG KEYCLOAK_IMAGE=quay.io/keycloak/keycloak:latest
FROM ${KEYCLOAK_IMAGE}

USER root

COPY configs/keycloak/base/keycloak.conf /opt/keycloak/conf/keycloak.conf
COPY images/keycloak/scripts/ /opt/keycloak/scripts/

RUN chmod 0755 /opt/keycloak/scripts/*.sh \
    && mkdir -p /opt/keycloak/data/import /opt/keycloak/certs /opt/keycloak/providers

USER 1000

ENTRYPOINT ["/opt/keycloak/scripts/startup.sh"]
