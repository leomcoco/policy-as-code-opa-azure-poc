# Policy as Code PoC (OPA) — Azure + Terraform (Sandbox)

Este repositório implementa uma Prova de Conceito (PoC) de **Policy as Code** usando **Open Policy Agent (OPA)** para validar regras de governança **antes do deploy** (shift-left), com foco em **Azure** e **Terraform Plan JSON**.

O objetivo é demonstrar um modelo “pronto para escalar”: regras versionadas, revisadas via Pull Request, testadas em CI, documentadas e com rollback simples.

---

## Por que esta PoC existe

Em ambientes cloud com múltiplas squads e alta cadência de mudanças, governança manual não escala. Policy as Code transforma regras em capacidade de plataforma:

- **Padronização**: mesmas regras para todos os times/pipelines.
- **Rastreabilidade**: PR → review → CI → merge (auditoria nativa no Git).
- **Qualidade**: testes automatizados e gates antes do merge.
- **Segurança operacional**: rollback rápido via revert.
- **Evolução contínua**: melhorias iterativas com histórico e métricas.

---

## Escopo

### Inclui
- Policies em **Rego** (OPA) para governança.
- Testes automatizados (OPA unit tests).
- Avaliação de políticas contra **Terraform plan JSON**.
- Documentação por policy (objetivo, inputs, allow/deny, decisão, testes, rollback).
- Governança do repositório (CODEOWNERS, PR template, regras de merge).

### Não inclui (nesta fase)
- Deploy/enforcement nativo no Azure (isso é papel de **Azure Policy**).
- Enforcement em runtime (ex.: Kubernetes admission controller).
- Integração com todos os toolchains corporativos (é PoC em sandbox).

---

## Como usar (Quickstart)

### 1) Pré-requisitos (local)
- **OPA** (binário `opa`) no PATH
- **Terraform**
- (Opcional) `jq` para inspecionar JSON

Verifique:
```bash
opa version
terraform version
