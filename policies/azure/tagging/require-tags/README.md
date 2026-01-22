# Require Mandatory Tags (Terraform plan JSON / AzureRM)

## Objetivo
Validar, em **shift-left**, que recursos Azure provisionados via Terraform possuam tags obrigatórias e valores válidos, antes do deploy.

## Input suportado
- `terraform show -json tfplan.binary` (Terraform plan JSON)
- A policy avalia `input.resource_changes[*].change.after.tags` (ou `tags_all`).

## Como rodar localmente

### 1) Testes unitários do Rego
```bash
opa fmt -w ./policies
opa test -v ./policies
