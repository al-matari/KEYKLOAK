SHELL := /bin/bash

ENV_FILE ?= .env.local
TF_DIR ?= terraform
TF_VARS ?= envs/local/terraform.tfvars

COMPOSE_BASE = docker compose --project-directory . --env-file $(ENV_FILE) -f compose/compose.yaml -f compose/compose.dev.yaml
COMPOSE_KAFKA = $(COMPOSE_BASE) -f compose/compose.kafka.yaml
COMPOSE_MONITORING = $(COMPOSE_BASE) -f compose/compose.monitoring.yaml
COMPOSE_TOOLS = $(COMPOSE_BASE) -f compose/compose.tools.yaml

.PHONY: help env up down down-all logs ps wait kafka-up kafka-down monitoring-up monitoring-down tools-up tools-down terraform-init terraform-validate terraform-plan terraform-apply provision-local bootstrap-local

help: ## Verfuegbare Targets anzeigen
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*## "}; {printf "%-18s %s\n", $$1, $$2}'

env: ## .env.local aus .env.example erzeugen, falls sie fehlt
	@test -f $(ENV_FILE) || cp .env.example $(ENV_FILE)

up: env ## Basis-Stack lokal starten, ohne Terraform
	$(COMPOSE_BASE) up -d --build

down: env ## Basis-Stack stoppen
	$(COMPOSE_BASE) down

down-all: env ## Basis-Stack inklusive Monitoring und Tools stoppen
	$(COMPOSE_KAFKA) down || true
	$(COMPOSE_TOOLS) down || true
	$(COMPOSE_MONITORING) down || true
	$(COMPOSE_BASE) down

logs: env ## Logs von Keycloak, Postgres und MailHog anzeigen
	$(COMPOSE_BASE) logs -f keycloak postgres mailhog

ps: env ## Aktive Container anzeigen
	$(COMPOSE_BASE) ps

wait: ## Auf die Keycloak-Readiness des Compose-Stacks warten
	./scripts/dev/wait-for-keycloak.sh

kafka-up: env ## Kafka-Overlay starten
	$(COMPOSE_KAFKA) up -d

kafka-down: env ## Kafka-Overlay stoppen
	$(COMPOSE_KAFKA) down

monitoring-up: env ## Prometheus und Grafana starten
	$(COMPOSE_MONITORING) up -d

monitoring-down: env ## Prometheus und Grafana stoppen
	$(COMPOSE_MONITORING) down

tools-up: env ## Admin-, Export- und Provisioning-Tools starten
	$(COMPOSE_TOOLS) up -d adminer keycloak-tools provisioning-runner

tools-down: env ## Admin-, Export- und Provisioning-Tools stoppen
	$(COMPOSE_TOOLS) rm -fs adminer keycloak-tools provisioning-runner || true

terraform-init: ## Terraform initialisieren
	terraform -chdir=$(TF_DIR) init

terraform-validate: ## Terraform-Konfiguration validieren
	terraform -chdir=$(TF_DIR) validate

terraform-plan: ## Terraform-Plan fuer local ausfuehren
	terraform -chdir=$(TF_DIR) plan -var-file=$(TF_VARS)

terraform-apply: ## Terraform-Apply fuer local ausfuehren
	terraform -chdir=$(TF_DIR) apply -var-file=$(TF_VARS)

provision-local: wait terraform-init terraform-apply ## Laufenden Compose-Stack per Terraform provisionieren

bootstrap-local: up provision-local ## Compose starten und anschliessend Terraform anwenden
