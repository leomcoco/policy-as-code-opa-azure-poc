# policy-as-code-opa-azure-poc

Proof-of-Concept (PoC) for **Policy as Code** using **Open Policy Agent (OPA)** and **Rego**, with an Azure-oriented repository layout.
This repo is designed to be simple, reproducible, and CI-driven.

## Goals
- Validate Rego policies with `opa fmt` and `opa test` on every Pull Request
- Package policies as an OPA bundle
- Generate a **Terraform plan in JSON** during CI (shift-left) to enable policy checks against IaC changes

## Repository Structure
- `policies/`  
  Rego policies and tests (unit tests).
- `examples/terraform/`  
  Simple Terraform stack used **only** to generate a `terraform plan` and export it as JSON.
- `.github/workflows/`  
  CI workflows (OPA tests, Terraform plan artifact, release bundle).
- `docs/`  
  Architecture and governance documents.

## Prerequisites (local)
- OPA installed (optional for local dev)
- Terraform 1.6+ (for the example stack)

## Local - OPA
Run formatting check and tests:

```bash
opa fmt -w ./policies
opa test -v ./policies
