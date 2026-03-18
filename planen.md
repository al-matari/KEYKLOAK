KEYKLOAK/
├── .env.example
├── .gitignore
├── README.md
├── Makefile
│
├── compose/
│   ├── compose.yaml
│   ├── compose.dev.yaml
│   ├── compose.kafka.yaml
│   ├── compose.monitoring.yaml
│   └── compose.tools.yaml
│
├── docs/
│   ├── architecture/
│   │   ├── overview.md
│   │   ├── zero-trust-login.md
│   │   ├── provisioning.md
│   │   ├── kafka-eventing.md
│   │   ├── realms-and-clients.md
│   │   ├── roles-and-groups.md
│   │   └── disaster-recovery.md
│   ├── development/
│   │   ├── local-setup.md
│   │   ├── build-and-release.md
│   │   ├── spi-development.md
│   │   ├── testing.md
│   │   └── coding-guidelines.md
│   └── operations/
│       ├── runbook.md
│       ├── backup-restore.md
│       ├── realm-import-export.md
│       ├── key-rotation.md
│       ├── incident-response.md
│       └── troubleshooting.md
│
├── configs/
│   ├── keycloak/
│   │   ├── base/
│   │   │   ├── keycloak.conf
│   │   │   ├── cache-ispn.xml
│   │   │   ├── logging.properties
│   │   │   └── health.properties
│   │   ├── dev/
│   │   │   ├── keycloak.conf
│   │   │   └── realm-import/
│   │   │       ├── realm-dev.json
│   │   │       ├── clients-dev.json
│   │   │       └── users-dev.json
│   │   ├── stage/
│   │   │   ├── keycloak.conf
│   │   │   └── realm-import/
│   │   │       └── realm-stage.json
│   │   ├── prod/
│   │   │   ├── keycloak.conf
│   │   │   └── realm-import/
│   │   │       └── realm-prod-template.json
│   │   ├── flows/
│   │   │   ├── browser-zero-trust-flow.json
│   │   │   ├── admin-zero-trust-flow.json
│   │   │   └── service-account-flow-notes.md
│   │   ├── themes/
│   │   │   └── enterprise-theme/
│   │   │       ├── login/
│   │   │       ├── account/
│   │   │       ├── email/
│   │   │       ├── admin/
│   │   │       ├── resources/
│   │   │       │   ├── css/
│   │   │       │   ├── js/
│   │   │       │   ├── img/
│   │   │       │   └── fonts/
│   │   │       └── theme.properties
│   │   └── realm-bootstrap/
│   │       ├── groups.json
│   │       ├── roles.json
│   │       ├── client-scopes.json
│   │       └── required-actions.json
│   │
│   ├── postgres/
│   │   ├── init/
│   │   │   └── 01-init.sql
│   │   └── backups/
│   │       └── retention-policy.md
│   │
│   ├── kafka/
│   │   ├── topics/
│   │   │   ├── identity-auth-events.json
│   │   │   ├── identity-admin-events.json
│   │   │   ├── identity-risk-events.json
│   │   │   └── identity-provisioning-events.json
│   │   ├── schemas/
│   │   │   ├── auth-event.schema.json
│   │   │   ├── admin-event.schema.json
│   │   │   ├── risk-event.schema.json
│   │   │   └── provisioning-event.schema.json
│   │   └── acl/
│   │       └── acl-notes.md
│   │
│   ├── monitoring/
│   │   ├── prometheus/
│   │   │   └── prometheus.yml
│   │   ├── grafana/
│   │   │   ├── dashboards/
│   │   │   └── datasources/
│   │   ├── loki/
│   │   │   └── loki-config.yml
│   │   └── promtail/
│   │       └── promtail-config.yml
│   │
│   └── reverse-proxy/
│       ├── traefik.yml
│       └── dynamic/
│           ├── tls.yml
│           └── routers.yml
│
├── docker/
│   ├── keycloak/
│   │   ├── Dockerfile
│   │   ├── providers/
│   │   │   └── .gitkeep
│   │   ├── scripts/
│   │   │   ├── healthcheck.sh
│   │   │   ├── startup.sh
│   │   │   ├── import-realms.sh
│   │   │   └── wait-for-db.sh
│   │   └── certs/
│   │       └── .gitkeep
│   │
│   ├── provisioning/
│   │   ├── Dockerfile
│   │   └── scripts/
│   │       ├── sync-users.sh
│   │       ├── disable-leavers.sh
│   │       └── reconcile-groups.sh
│   │
│   └── tools/
│       ├── Dockerfile
│       └── scripts/
│           ├── export-realm.sh
│           ├── rotate-keys.sh
│           └── create-test-data.sh
│
├── code/
│   ├── pom.xml
│   ├── settings.xml
│   ├── shared/
│   ├── providers/
│   │   ├── authenticator/
│   │   ├── required-action/
│   │   ├── protocol-mapper/
│   │   ├── event-listener/
│   │   ├── rest-extension/
│   │   ├── identity-provider-mapper/
│   │   ├── authorization/
│   │   └── user-storage/
│   ├── services/
│   │   ├── provisioning-service/
│   │   ├── risk-engine/
│   │   └── audit-consumer/
│   └── tests/
│       ├── integration/
│       ├── contract/
│       ├── performance/
│       └── security/
│
├── artifacts/
│   ├── providers/
│   └── reports/
│
├── provisioning/
│   ├── mappings/
│   ├── workflows/
│   ├── seeds/
│   └── reconciliation/
│
├── terraform/
│   ├── versions.tf
│   ├── providers.tf
│   ├── backend.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── modules/
│   │   ├── realm/
│   │   ├── clients/
│   │   ├── client-scopes/
│   │   ├── groups/
│   │   ├── roles/
│   │   ├── mappers/
│   │   ├── identity-providers/
│   │   ├── authentication-flows/
│   │   └── realm-settings/
│   ├── envs/
│   │   ├── dev/
│   │   ├── stage/
│   │   └── prod/
│   └── import/
│
├── observability/
│   ├── dashboards/
│   ├── alerts/
│   └── slo/
│
├── scripts/
│   ├── bootstrap/
│   ├── build/
│   ├── test/
│   ├── ops/
│   └── dev/
│
├── secrets/
│   ├── README.md
│   ├── dev/
│   ├── stage/
│   └── prod/
│
└── tmp/
    └── .gitkeep