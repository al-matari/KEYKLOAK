

keycloak-enterprise/
├── .env
├── .env.example
├── .gitignore
├── README.md
│
├── compose/
│   ├── docker-compose.yml
│   ├── docker-compose.override.yml
│   ├── docker-compose.monitoring.yml
│   └── docker-compose.messaging.yml
│
├── secrets/
│   ├── keycloak_admin_password.txt
│   ├── postgres_password.txt
│   ├── grafana_admin_password.txt
│   ├── kafka_password.txt
│   └── smtp_password.txt
│
├── traefik/
│   ├── traefik.yml
│   ├── dynamic/
│   │   ├── routers.yml
│   │   ├── middlewares.yml
│   │   └── tls.yml
│   ├── certs/
│   │   ├── fullchain.pem
│   │   └── privkey.pem
│   └── acme/
│       └── acme.json
│
├── keycloak/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── providers/
│   ├── themes/
│   ├── realm-import/
│   │   └── example-realm.json
│   ├── conf/
│   │   ├── keycloak.conf
│   │   └── cache-ispn.xml
│   └── extensions/
│       └── event-listener/
│
├── postgres/
│   ├── init/
│   │   ├── 01-init-db.sql
│   │   └── 02-create-extensions.sql
│   ├── conf/
│   │   └── postgresql.conf
│   ├── scripts/
│   │   ├── backup.sh
│   │   └── restore.sh
│   └── backups/
│
├── monitoring/
│   ├── prometheus/
│   │   ├── prometheus.yml
│   │   └── rules/
│   │       ├── keycloak-alerts.yml
│   │       └── postgres-alerts.yml
│   ├── grafana/
│   │   ├── provisioning/
│   │   │   ├── datasources/
│   │   │   │   ├── prometheus.yml
│   │   │   │   └── loki.yml
│   │   │   └── dashboards/
│   │   │       └── dashboards.yml
│   │   └── dashboards/
│   │       ├── keycloak-overview.json
│   │       ├── postgres-overview.json
│   │       └── docker-host-overview.json
│   └── alertmanager/
│       └── alertmanager.yml
│
├── logging/
│   ├── loki/
│   │   └── loki-config.yml
│   ├── promtail/
│   │   └── promtail-config.yml
│   └── otel-collector/
│       └── otel-collector-config.yml
│
├── messaging/
│   ├── kafka/
│   │   ├── server.properties
│   │   └── jaas.conf
│   ├── zookeeper/
│   │   └── zoo.cfg
│   └── consumers/
│       └── keycloak-events/
│           ├── Dockerfile
│           └── app/
│               └── main.py
│
├── backup/
│   ├── pg_dump/
│   │   └── backup.sh
│   ├── retention/
│   │   └── cleanup.sh
│   └── restore/
│       └── restore.sh
│
├── scripts/
│   ├── init.sh
│   ├── up.sh
│   ├── down.sh
│   ├── restart.sh
│   ├── logs.sh
│   ├── ps.sh
│   ├── healthcheck.sh
│   ├── create-secrets.sh
│   └── rotate-secrets.sh
│
├── tests/
│   ├── smoke/
│   │   ├── login-flow.sh
│   │   └── health-endpoints.sh
│   └── load/
│       └── k6-login.js
│
└── ops/
    ├── runbooks/
    │   ├── backup-restore.md
    │   ├── keycloak-upgrade.md
    │   ├── incident-response.md
    │   └── realm-migration.md
    ├── checklists/
    │   ├── production-readiness.md
    │   └── go-live.md
    └── diagrams/
        └── architecture.md