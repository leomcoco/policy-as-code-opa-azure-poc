# docs/policy-lifecycle.md

# Policy Lifecycle (Policy as Code / OPA PoC)

This document defines the lifecycle for policies managed as code in this repository. The goal is to ensure every policy change is **reviewed, tested, traceable, and reversible**.

---

## 1. Policy Stages

### 1.1 Draft
A policy is considered **Draft** when:
- The rule exists but may be incomplete or experimental.
- Tests may be partial.
- Enforcement is typically **Warn/Audit** (non-blocking) or not yet integrated into consuming pipelines.

**Exit criteria (to move to Active):**
- Clear objective and scope defined in documentation.
- At least one allow and one deny test case.
- Peer review completed (CODEOWNERS when applicable).
- CI checks passing.

---

### 1.2 Active
A policy is **Active** when:
- It is stable and has adequate test coverage.
- It is integrated into CI/CD (or planned integration path is documented).
- It has a defined rollback path.

**Expectations:**
- Changes must preserve backward compatibility unless explicitly stated.
- Breaking changes require migration notes and stakeholder awareness.

---

### 1.3 Deprecated
A policy is **Deprecated** when:
- It is replaced by a newer rule, merged into another policy, or no longer applicable.
- It should not be extended further, except for critical fixes.

**Exit criteria:**
- Replacement path documented.
- Removal plan defined (date/version if applicable).

---

## 2. Policy Development Workflow

### Step 1 — Create / Update Policy
- Implement rule logic (OPA/Rego).
- Add or update unit tests.
- Add documentation in `docs/policies/<policy-id>.md`.

**Outputs:**
- Rego changes
- Tests
- Policy documentation

---

### Step 2 — Pull Request (PR)
All changes must go through a PR.

**PR must include:**
- Summary (what/why)
- Policy impact assessment
- Test evidence
- Rollback / mitigation plan

**Gate:**
- Minimum approvals (at least 1)
- CODEOWNERS review for changes under policy paths (if enforced)

---

### Step 3 — CI Validation
CI must validate:
- Policy tests (OPA)
- Repository hygiene checks (lint/format when available)

**Gate:**
- Required checks must pass before merge (once configured).

---

### Step 4 — Merge to Main
After approvals and CI success, PR is merged to `main`.

**Expected outcomes:**
- `main` is always in a releasable state.
- Every change is traceable to a PR.

---

### Step 5 — Release / Bundle (if applicable)
If the repo produces policy bundles or releases:
- Create a versioned artifact (tag/release).
- Track the release version that is deployed/consumed.

**Recommendations:**
- Semantic versioning:
  - PATCH: fixes, internal refactors
  - MINOR: new rule or new allow/deny scenarios without breaking existing behavior
  - MAJOR: breaking changes in evaluation semantics

---

### Step 6 — Consumption / Enforcement
Policies can be consumed by:
- CI “shift-left” validations (Terraform plan checks, etc.)
- Admission control (Kubernetes)
- Deployment gates (platform pipelines)

**Enforcement levels:**
- Informational: emits messages only
- Warn/Audit: warns but does not block
- Deny: blocks noncompliant changes

---

### Step 7 — Monitoring and Feedback
For policies used in pipelines, track:
- Deny rates (false positives indicators)
- Common violation patterns
- Exceptions frequency

Use this feedback to:
- Improve scoping
- Refine error messages
- Add missing test cases

---

## 3. Exception Handling

Exceptions should be:
- Explicit
- Minimal scope (resource, environment, time)
- Reviewable and reversible

Recommended approaches:
- Controlled exception list in data (e.g., `data.exemptions`)
- Context-driven exemptions in input (e.g., `input.context.exemptions`)
- Temporary mitigation by lowering enforcement (Warn/Audit) while investigating

All exceptions must be documented:
- Who approved
- Why required
- Expiration/review date (if applicable)

---

## 4. Breaking Changes Policy

A change is considered breaking if it:
- Turns previously allowed cases into denied cases broadly
- Changes input contract expectations
- Alters decision outputs in a way that consumers must adapt

Breaking changes require:
- Clear PR labeling (e.g., `breaking-change`)
- Migration notes in policy docs
- Strong rollback plan

---

## 5. Rollback Strategy

Preferred rollback is:
1. Revert the PR (fastest)
2. Roll back to last known good release/tag (if using bundles/releases)
3. Temporary mitigation:
   - Switch enforcement to Warn/Audit (if supported by consumer)
   - Add a scoped exception (time-bound) while investigating

Rollback must be:
- Documented in PR
- Easy to execute in minutes, not hours

---

## 6. Definition of Done (DoD)

A policy change is “done” when:
- [ ] Documentation updated (`docs/policies/<policy-id>.md`)
- [ ] Tests added/updated (allow + deny cases)
- [ ] PR template checklist completed
- [ ] CI checks passed
- [ ] Rollback plan provided
- [ ] Review completed (CODEOWNERS when applicable)
