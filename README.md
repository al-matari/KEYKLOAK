# Keycloak Local Platform

Dieses Repository orientiert sich jetzt deutlich staerker an einer `keycloak-enterprise`-artigen Struktur: ein lauffaehiger lokaler Stack als Einstieg, dazu getrennte Bereiche fuer Konfiguration, Dokumentation, Erweiterungen, Provisioning, Deployment und Observability. Das bestehende `terraform/`-Modul bleibt dabei der funktionale Kern fuer Realm- und Client-Provisionierung.

## Struktur

```text
.
├── .env.example
├── Makefile
├── code/
├── compose/
│   ├── compose.yaml
│   ├── compose.dev.yaml
│   ├── compose.kafka.yaml
│   ├── compose.monitoring.yaml
│   └── compose.tools.yaml
├── configs/
│   ├── keycloak/
│   ├── kafka/
│   ├── monitoring/
│   ├── postgres/
│   └── reverse-proxy/
├── deployment/
├── docker/
│   ├── keycloak/
│   ├── provisioning/
│   └── tools/
├── docs/
│   ├── architecture/
│   ├── development/
│   └── operations/
├── provisioning/
├── observability/
├── scripts/
│   ├── bootstrap/
│   ├── build/
│   ├── dev/
│   ├── ops/
│   └── test/
├── secrets/
├── terraform/
├── artifacts/
└── tmp/
```

## Schnellstart

```bash
cp .env.example .env.local
make up
make wait
```

Damit laeuft der lokale Compose-Stack bereits ohne Terraform.

## Optionales Terraform-Provisioning

```bash
make terraform-init
make terraform-apply
```

Danach ist erreichbar:

- Keycloak: `http://localhost:8080`
- Java Debug: `localhost:8787`
- MailHog UI: `http://localhost:8025`
- Prometheus: `http://localhost:9090` mit `make monitoring-up`
- Grafana: `http://localhost:3000` mit `make monitoring-up`
- Loki: `http://localhost:3100` mit `make monitoring-up`
- Promtail: `http://localhost:9080` mit `make monitoring-up`
- Adminer: `http://localhost:8088` mit `make tools-up`
- `keycloak-tools`: laufender Tool-Container fuer Export- und Admin-Skripte mit `make tools-up`
- `provisioning-runner`: laufender Container fuer Sync-, Disable- und Reconciliation-Skripte mit `make tools-up`
- Kafka UI: `http://localhost:8089` mit `make kafka-up`

Die lokalen Terraform-Werte in [terraform/envs/local/terraform.tfvars](/Users/mohammedal-matari/Documents/GitHub/ai/codex/keycloak/terraform/envs/local/terraform.tfvars) passen bereits auf dieses Setup:

- Keycloak unter `http://localhost:8080`
- Admin-Login `admin` / `admin`
- SMTP ueber MailHog auf `localhost:1025`

## Wichtige Targets

```bash
make up                # Basis-Stack ohne Terraform starten
make provision-local   # laufenden Stack per Terraform provisionieren
make kafka-up          # Kafka + UI dazuschalten
make monitoring-up     # Prometheus + Grafana dazuschalten
make tools-up          # Admin-, Export- und Provisioning-Tools dazuschalten
make wait              # Auf Keycloak Readiness warten
make logs              # Keycloak/Postgres/MailHog Logs
make bootstrap-local   # Compose starten und danach Terraform anwenden
make down-all          # Alles wieder stoppen
```

## Hinweise

- [compose/compose.yaml](/Users/mohammedal-matari/Documents/GitHub/ai/codex/keycloak/compose/compose.yaml) ist die Basisdatei fuer den Stack.
- Der Compose-Stack laeuft bewusst eigenstaendig; Terraform ist nur fuer die nachgelagerte Provisionierung gedacht.
- `compose/compose.dev.yaml` schaltet lokales `start-dev` und Realm-Import-Verzeichnis ein.
- `compose/compose.dev.yaml` aktiviert zusaetzlich Realm-Import, den Java-Debug-Port `8787` und besser verfolgbares Live-Logging fuer den Dev-Container.
- `compose/compose.kafka.yaml` schaltet ein lokales Kafka-Overlay mit UI dazu.
- `compose/compose.monitoring.yaml` startet Prometheus, Grafana, Loki und Promtail zusammen.
- `compose/compose.tools.yaml` startet Adminer sowie getrennte Tool- und Provisioning-Container fuer manuelle Admin-, Export- und Sync-Aufgaben.
- Unterstuetztes Keycloak-Cache-Tuning liegt fuer lokal zuerst in [configs/keycloak/dev/keycloak.conf](/Users/mohammedal-matari/Documents/GitHub/ai/codex/keycloak/configs/keycloak/dev/keycloak.conf) und [configs/keycloak/base/keycloak.conf](/Users/mohammedal-matari/Documents/GitHub/ai/codex/keycloak/configs/keycloak/base/keycloak.conf) ueber `cache-embedded-*-max-count`.
- [configs/keycloak/base/cache-ispn.xml](/Users/mohammedal-matari/Documents/GitHub/ai/codex/keycloak/configs/keycloak/base/cache-ispn.xml) ist fuer fortgeschrittene XML-Overrides gedacht, nicht fuer das normale lokale Feintuning.
- `configs/keycloak/dev/realm-import/` ist fuer spaetere JSON-Importe vorbereitet.
- `docker/keycloak/` kapselt den lokalen Start von Keycloak, damit Compose- und Terraform-Setup sauber getrennt bleiben.
- `code/`, `provisioning/`, `deployment/` und `observability/` sind bewusst als Enterprise-Scaffold angelegt und koennen jetzt iterativ gefuellt werden.

Mehr Details stehen in [docs/development/local-setup.md](/Users/mohammedal-matari/Documents/GitHub/ai/codex/keycloak/docs/development/local-setup.md) und [terraform/README.md](/Users/mohammedal-matari/Documents/GitHub/ai/codex/keycloak/terraform/README.md).
