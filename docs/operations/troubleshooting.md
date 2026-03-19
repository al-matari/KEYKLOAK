# Troubleshooting

## Keycloak wird nicht ready

- `make logs` ausfuehren und auf Datenbank- oder Konfigurationsfehler pruefen.
- Sicherstellen, dass Port `8080` und `9000` lokal frei sind.
- Bei einem frischen Neustart gegebenenfalls `make down-all` und danach `make up` ausfuehren.

## Terraform kann sich nicht anmelden

- Pruefen, ob `make wait` erfolgreich war.
- Die Werte in `terraform/envs/local/terraform.tfvars` muessen nur dann zu `.env.local` passen, wenn Terraform gegen den lokalen Compose-Stack laufen soll.
- Standardmaessig wird lokal `admin-cli` mit `admin` / `admin` verwendet.

## SMTP kommt nicht an

- MailHog unter `http://localhost:8025` pruefen.
- In `terraform/envs/local/terraform.tfvars` ist SMTP auf `localhost:1025` vorkonfiguriert.
