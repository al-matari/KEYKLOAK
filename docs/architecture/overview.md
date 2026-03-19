# Architekturueberblick

Das Repository trennt jetzt klar zwischen Runtime, Konfiguration und Provisionierung:

- `compose/compose.yaml` ist die Basis fuer den lokalen Stack.
- `compose/` enthaelt zusaetzliche Overlays fuer `dev`, `kafka`, `monitoring` und `tools`.
- `configs/` enthaelt dateibasierte Runtime-Konfiguration fuer Keycloak, Postgres und Monitoring.
- `docker/` kapselt container-spezifische Startlogik, damit Compose-Dateien schlank bleiben.
- `terraform/` bleibt die Quelle fuer Realm-, Client-, Rollen- und Benutzer-Provisionierung.
- `code/`, `provisioning/`, `deployment/` und `observability/` bilden den Enterprise-Scaffold fuer Erweiterungen und den spaeteren Betriebsweg.

Der lokale Ablauf ist bewusst einfach:

1. Postgres startet als Persistenz.
2. Keycloak verbindet sich mit Postgres und stellt Health- und Metrics-Endpunkte bereit.
3. MailHog nimmt lokale SMTP-Mails entgegen.
4. Terraform provisioniert anschliessend den Realm `demo-local` und die Clients aus `terraform/envs/local/terraform.tfvars`.

Diese Struktur ist so angelegt, dass spaeter weitere Bereiche wie Kafka, Custom Provider oder Reverse Proxy ohne grosses Umraumen ergaenzt werden koennen.
