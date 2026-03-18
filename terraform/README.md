# Keycloak Terraform Platform

`terraform/` ist jetzt naeher an einer klassischen Enterprise-Struktur aufgebaut: ein klares Root-Modul, getrennte Environment-Daten, Domänenmodule und ein eigener Bereich fuer Imports.

## Struktur

```text
terraform/
├── versions.tf
├── providers.tf
├── backend.tf
├── variables.tf
├── outputs.tf
├── realm.tf
├── clients.tf
├── modules/
│   ├── realm/
│   ├── clients/
│   ├── client-roles/
│   ├── client-scopes/
│   ├── realm-settings/
│   ├── roles/
│   ├── groups/
│   ├── users/
│   ├── mappers/
│   ├── identity-providers/
│   └── authentication-flows/
├── envs/
│   ├── dev/
│   │   └── terraform.tfvars.example
│   └── local/
│       ├── terraform.tfvars
│       └── terraform.tfvars.example
└── import/
    ├── import-realm.sh
    ├── import-clients.sh
    └── import-groups.sh
```

## Architekturidee

- `realm.tf` orchestriert den Realm-Bereich ueber ein Wrapper-Modul.
- `clients.tf` orchestriert Clients getrennt von Client-Rollen und Client-Scope-Mappings.
- `modules/` ist nach fachlichen Domänen aufgeteilt statt nach einer einzigen grossen Sammel-Logik.
- `envs/` enthaelt nur noch umgebungsspezifische Werte.
- `import/` ist der Startpunkt fuer Import-Workflows und spaetere Migrationsskripte.

## Lokal ausfuehren

Zuerst den lokalen Docker-Stack aus dem Repository-Root starten:

```bash
cp docker/.env.local.example docker/.env.local
docker compose --env-file docker/.env.local -f docker/compose.local.yml up -d --build
```

Danach Terraform ausfuehren:

```bash
terraform -chdir=terraform init
terraform -chdir=terraform plan -var-file=envs/local/terraform.tfvars
terraform -chdir=terraform apply -var-file=envs/local/terraform.tfvars
```

`envs/local/terraform.tfvars` ist auf `http://localhost:8080`, SMTP auf `localhost:1025` und Passwort-Grant ueber `admin-cli` ausgelegt.

## Neues Environment anlegen

```bash
cp terraform/envs/dev/terraform.tfvars.example terraform/envs/dev/terraform.tfvars
terraform -chdir=terraform plan -var-file=envs/dev/terraform.tfvars
```

## Umfang

Direkt umgesetzt sind:

- Realm-Core-Settings fuer Login, Tokens, Sessions, OTP, WebAuthn, SMTP, Themes, Localization und Security Headers
- Realm Roles, Default Roles, Groups, Users und Memberships
- LDAP Federation und Mapper
- OIDC Identity Provider fuer Google, Azure AD und Apple
- OIDC Clients fuer Bearer-only, Confidential, Public und Service Account
- Client-Rollen, Scope-Mappings, Service-Account-Rollenzuweisungen und Protocol Mappers

Als vorbereitete Struktur vorhanden:

- `authentication-flows`
- `import/`
- weitere env-spezifische Aufteilung unter `envs/`
