# Lokales Setup

## Voraussetzungen

- Docker inklusive `docker compose`
- `curl` fuer den lokalen Readiness-Check

Fuer optionales Provisioning zusaetzlich:

- Terraform ab `1.5`

## Compose Start

```bash
cp .env.example .env.local
docker compose --project-directory . --env-file .env.local -f compose/compose.yaml -f compose/compose.dev.yaml up -d --build
make wait
```

oder ueber das `Makefile`:

```bash
cp .env.example .env.local
make up
make wait
```

Damit laeuft Keycloak lokal bereits komplett ueber Docker Compose. Terraform ist dafuer nicht erforderlich.

## Optionales Terraform-Provisioning

```bash
make terraform-init
make terraform-apply
```

oder als kombinierter Komfort-Workflow:

```bash
make provision-local
```

## Optional

```bash
make monitoring-up
make tools-up
make kafka-up
```

## Wichtige URLs

- Keycloak: `http://localhost:8080`
- Java Debug: `localhost:8787`
- MailHog: `http://localhost:8025`
- Prometheus: `http://localhost:9090`
- Grafana: `http://localhost:3000`
- Loki: `http://localhost:3100`
- Promtail: `http://localhost:9080`
- Adminer: `http://localhost:8088`

## Tools Overlay

Mit `make tools-up` startest du:

- `adminer` fuer Datenbank-Administration
- `keycloak-tools` fuer Export-, Key-Rotation- und Testdaten-Skripte
- `provisioning-runner` fuer Provisioning- und Reconciliation-Skripte

Das Tools-Overlay ist dabei nicht an einen Terraform-Lauf gekoppelt.

## Realm-Import vorbereiten

Wenn du spaeter JSON-Exporte per Keycloak-Import laden willst, lege sie in `configs/keycloak/dev/realm-import/` ab. Das Dev-Overlay schaltet `--import-realm` automatisch ein, sobald dort Dateien liegen.

## Debug Und Live Logs

- Remote-Debug ist lokal auf Port `8787` aktiviert.
- Live-Logs bekommst du ueber `make logs`.
- Das Dev-Overlay startet Keycloak mit zusaetzlich detailreicheren Event- und Service-Logs.

## Cache Tuning Lokal

Fuer lokales Keycloak-Cache-Tuning ist der unterstuetzte Ort zuerst:

- [configs/keycloak/dev/keycloak.conf](/Users/mohammedal-matari/Documents/GitHub/ai/codex/keycloak/configs/keycloak/dev/keycloak.conf)
- [configs/keycloak/base/keycloak.conf](/Users/mohammedal-matari/Documents/GitHub/ai/codex/keycloak/configs/keycloak/base/keycloak.conf)

Nutze dort die `cache-embedded-*-max-count` Optionen. 
[configs/keycloak/base/cache-ispn.xml](/Users/mohammedal-matari/Documents/GitHub/ai/codex/keycloak/configs/keycloak/base/cache-ispn.xml) sollte nur fuer fortgeschrittene XML-Overrides verwendet werden.

## Weitere Scaffold-Bereiche

- `code/` ist fuer spaetere SPI- und Service-Implementierungen vorbereitet.
- `provisioning/` enthaelt Platz fuer Mappings, Seeds und Reconciliation-Workflows.
- `deployment/` enthaelt Kubernetes-, Helm- und CI-Scaffolds.
