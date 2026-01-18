# CONTRIBUTING.md

# Contributing Guide (Policy as Code / OPA PoC)

Thank you for contributing to this repository. This repo is part of a Proof of Concept (PoC) for **Policy as Code** using **OPA** (Open Policy Agent) and related tooling to validate and enforce governance rules **before deployment**.

## Scope and Goals

This repository aims to:
- Define policies as code (OPA/Rego) and supporting artifacts (schemas, test cases, documentation).
- Validate changes through pull requests with review, automated checks, and traceable evidence.
- Provide repeatable patterns that can evolve into a centralized governance platform.

## Repository Structure (typical)

> Adjust if your repo structure differs.

- `policies/`  
  Policy definitions (Rego), data inputs, and examples.
- `opa/`  
  OPA-related bundles, helpers, tooling, and test assets.
- `.github/workflows/`  
  CI pipelines (lint, unit tests, policy tests, packaging).
- `docs/`  
  Documentation, decisions, and usage guidance.

## Working Model

### Branching
- Create branches from `main` using:
  - `feature/<short-description>`
  - `fix/<short-description>`
  - `chore/<short-description>`
  - `docs/<short-description>`

### Commits
Recommended convention:
- `feat: ...` new capability
- `fix: ...` defect fix
- `chore: ...` housekeeping
- `docs: ...` documentation updates
- `test: ...` tests only
- `refactor: ...` refactor without behavior change

## Pull Request Requirements

All changes must go through a Pull Request (PR). The PR must include:

1. **Clear summary** of what changed and why.
2. **Impact assessment** (what policies/rules are affected).
3. **Evidence** (test output, examples, screenshots if applicable).
4. **Rollback plan** (how to revert/mitigate if issues are found).

### Policy Change Rules (OPA/Rego)

When modifying or adding policies:
- Include or update **tests** for every new/changed rule.
- Add at least one **positive** (allowed) and one **negative** (denied) case.
- If changing semantics, document it under `docs/` (or in the PR description).

### Non-Policy Changes
For docs/CI/metadata changes, include:
- Proof that CI passes (or explain why it’s not applicable).
- For workflow changes, describe the reasoning and expected impact.

## Local Validation (recommended)

The repository may include CI steps for:
- Formatting/lint (Rego formatting, YAML checks)
- OPA tests
- Bundle build/validation

If you have these tools locally, run the equivalent of:
- `opa test ...` (policy unit tests)
- `opa eval ...` (spot-check rule behavior)

> If you don’t run locally, CI is the source of truth. Your PR must still provide evidence (CI run link or output snippet).

## Rollback / Mitigation Guidance

Policy rollbacks should be fast and low-risk:
- Prefer reverting the PR (single revert commit).
- If you use a “policy bundle” release process, revert to the last known good bundle/version.
- If policies are deployed to environments, ensure you can:
  - Disable enforcement (e.g., set effect to audit / disable in the consuming pipeline), or
  - Apply targeted exception while investigating.

## Review Process

### What reviewers check
- Correctness: rule logic matches intended governance requirement.
- Safety: no unintended broad denials; scoped conditions are appropriate.
- Test quality: meaningful cases, not only happy-path.
- Maintainability: readable Rego, clear naming, documentation updated.

### Approval rules
- At least 1 approval is required.
- Changes in policy folders should be reviewed by CODEOWNERS (when enabled).

## Security and Sensitive Data

Do not commit:
- Credentials, tokens, keys, certificates, connection strings.
- Customer or production data.

If you suspect sensitive content was committed, rotate/revoke immediately and purge history where necessary.

## Documentation Updates

If you change policy behavior, update docs:
- What changed
- Why it changed
- Examples of allowed/denied
- Migration notes (if applicable)

## Issue Reporting

Open an issue describing:
- Expected behavior vs actual behavior
- Repro inputs (sample JSON)
- OPA version / CI run link (if available)

## Code of Conduct

Be respectful and constructive in reviews and discussions.
