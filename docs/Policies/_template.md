# Require Mandatory Tags (Azure Resources)

## Metadata
- **ID:** `require-mandatory-tags`
- **Status:** Draft
- **Owner:** @leomcoco
- **Last updated:** 2026-01-18
- **Scope:** Azure (Terraform Plan JSON)
- **Enforcement:** Warn/Audit (PoC baseline) → Deny (quando maturar)

---

## Objective
Garantir que recursos provisionados no Azure via IaC tenham um conjunto mínimo de tags obrigatórias para habilitar governança, rastreabilidade e FinOps (custos, chargeback/showback, auditoria e inventário).

---

## Background and Rationale
Em ambientes multi-cloud e com múltiplas squads, o “padrão mínimo” de tags evita:
- perda de rastreabilidade de ownership e propósito do recurso;
- dificuldades em relatórios de custo (FinOps), compliance e auditoria;
- inconsistência operacional (automação e inventário dependem de metadados).

Trade-offs:
- Pode gerar fricção inicial (principalmente em PoC/sandbox).
- Exige política de exceções bem definida para recursos/serviços que não suportam tags ou para cenários temporários.

---

## Decision

### Policy Statement
“Recursos criados/alterados via Terraform devem conter todas as tags obrigatórias.”

### Decision Outcome
- **Allow when:**
  - O recurso possui todas as tags obrigatórias preenchidas; ou
  - O recurso se enquadra em exceção documentada (ex.: tipo não taggeável / recurso auxiliar); e
  - A mudança não é `delete` (remoção não
