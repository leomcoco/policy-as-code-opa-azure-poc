# Example Terraform (PoC)

Este exemplo existe apenas para gerar um `terraform plan` e exportar para JSON (`tfplan.json`),
que será usado na PoC de Policy as Code.

## Rodar localmente

```bash
cd examples/terraform
terraform init
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json
