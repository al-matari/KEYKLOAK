# Keycloak Realm Terraform Template

Dieses Template bildet die Realm-Konfiguration schlank in Terraform ab.

## Was direkt umgesetzt ist

- Realm als zentrale Resource
- Login-, Token-, Session-, OTP-, WebAuthn-, SMTP-, Theme-, Localization- und Header-Settings
- Default Realm Roles
- Realm Roles
- Groups und Group-Role-Mappings
- Users und User-Group-Mappings
- LDAP User Federation
- LDAP User Attribute Mapper
- OIDC Identity Provider für Google, Azure AD und Apple
- Identity-Provider-Mapper für OIDC Claims
- Username Template Importer für Broker-Logins
- OIDC Clients als eigenes Modul für Bearer-only, Confidential, Public und Service Account
- Client-Rollen, Scope-Mappings, Service-Account-Rollenzuweisungen und Protocol-Mappers für Clients

## Was als Scaffold erhalten bleibt

Einige Bereiche bleiben bewusst als Input-Struktur erhalten, auch wenn es dafür in diesem Template noch keine eigenen Terraform-Ressourcen gibt:

- components
- organizations
- verifiable_credentials

Diese Werte laufen aktuell als Metadaten in `realm-core.tf` mit, bis du sie gegen konkrete Provider-Resources austauschst. Konsolidierte Realm-Settings wie SMTP, Themes, Localization und Security Headers liegen zentral in `realm-core.tf` und nicht mehr in separaten Dummy-Dateien.

## Struktur

```text
.
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── env/
│   └── dev.tfvars
└── modules/
    ├── clients/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── roles.tf
    │   ├── scope-mappings.tf
    │   ├── protocol-mappers.tf
    │   ├── bearer-only.tf
    │   ├── confidential.tf
    │   ├── public.tf
    │   ├── service-account.tf
    │   └── versions.tf
    └── realm/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── realm-core.tf
        ├── default-role.tf
        ├── roles.tf
        ├── groups.tf
        ├── users.tf
        ├── user-federation-core.tf
        ├── user-federation-mapping.tf
        ├── identity-provider-mappers.tf
        ├── identity-providers-google.tf
        ├── identity-providers-azuread.tf
        └── identity-providers-apple.tf
```

## Start

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Lokal mit Keycloak auf localhost:8080

```bash
terraform init
terraform plan -var-file=env/local.tfvars
terraform apply -var-file=env/local.tfvars
```

`env/local.tfvars` ist auf `http://localhost:8080` und Passwort-Grant ueber `admin-cli` ausgelegt. Trage dort nur noch deinen lokalen Admin-Benutzer und das Passwort ein, falls sie von den Platzhaltern abweichen.

## Empfehlung

1. Erst `terraform.tfvars` mit echten Secrets befüllen.
2. Dann nur `realm`, `roles`, `groups`, `users` und `clients` aktiv testen.
3. Danach LDAP und Identity Provider einzeln zuschalten.
4. Für Clients kannst du die vier Typen direkt über den Block `clients = { ... }` in den tfvars pflegen, inklusive `roles`, `scope_mappings`, `service_account_roles` und `protocol_mappers`.
5. Scaffold-Inputs nur dann in echte Resources umbauen, wenn deine konkrete Provider-Version die Resource auch wirklich unterstützt.
