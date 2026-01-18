<!-- .github/pull_request_template.md -->

# Summary
<!-- What is being changed and why? Keep it concise. -->

## Type of change
- [ ] Policy change (OPA/Rego)
- [ ] Tests only
- [ ] CI / Workflow
- [ ] Documentation
- [ ] Refactor / Chore

# Policy Impact Assessment
<!-- Required for policy changes. If not applicable, write "N/A". -->

## Policies / packages affected
- [ ] `policies/...` (list paths/packages)
- [ ] `opa/...` (list paths/packages)
- [ ] Other: <!-- specify -->

## Expected behavior
<!-- Explain how the policy should behave after this change. -->
- Allowed when:
  - 
- Denied when:
  - 

## Risk analysis
- Blast radius (scope of resources/inputs affected):
- Potential false positives (legit deployments denied):
- Potential false negatives (bad deployments allowed):
- Backward compatibility concerns:

# Tests and Evidence

## What tests were executed?
- [ ] OPA unit tests (`opa test ...`)
- [ ] Policy evaluation spot-check (`opa eval ...`)
- [ ] CI pipeline run (link)
- [ ] Not run (explain)

## Evidence (paste output or link)
<!-- Paste relevant snippets or include a CI run link. -->
- CI run:
- Test output:

## Test cases added/updated
- [ ] Added positive (allowed) case(s)
- [ ] Added negative (denied) case(s)
- [ ] Updated existing tests

# Rollback / Mitigation Plan
<!-- Be explicit. How do we revert quickly if this breaks deployments? -->
- [ ] Revert PR (preferred)
- [ ] Roll back bundle/version to: <!-- last known good -->
- [ ] Temporary mitigation (audit/disable in consuming pipeline):
- [ ] Exception strategy (if applicable):

# Checklist
- [ ] I scoped the policy to the minimum necessary (avoid broad denies).
- [ ] I updated/added tests for new/changed rules.
- [ ] I updated documentation for behavior changes (if applicable).
- [ ] CI checks pass (or I explained why they do not).
- [ ] No secrets or sensitive data were included.

# Notes for Reviewers
<!-- Anything that helps reviewers: design rationale, edge cases, open questions -->
