#!/usr/bin/env bash
set -euo pipefail

if [ ! -d ".git" ]; then
  echo "ERRO: execute no ROOT do repositório (pasta que contém .git)"
  exit 1
fi

mkdir -p \
  policies/azure/tagging/require-tags \
  policies/azure/naming \
  policies/shared/libs \
  tests/fixtures \
  tests/integration \
  examples/terraform/plan-json \
  examples/pipelines \
  docs/adr \
  .github/workflows \
  .github/ISSUE_TEMPLATE

touch \
  policies/azure/tagging/require-tags/policy.rego \
  policies/azure/tagging/require-tags/policy_test.rego \
  policies/azure/tagging/require-tags/README.md \
  examples/terraform/README.md \
  docs/architecture.md \
  docs/governance-model.md \
  docs/policy-lifecycle.md \
  .github/workflows/ci.yml \
  .github/workflows/release-bundle.yml \
  .github/pull_request_template.md \
  .gitignore \
  LICENSE \
  CODEOWNERS \
  CONTRIBUTING.md \
  SECURITY.md \
  CHANGELOG.md \
  README.md

write_if_empty () {
  local file="$1"
  local content="$2"
  if [ ! -s "$file" ]; then
    printf "%b" "$content" > "$file"
  fi
}


write_if_empty README.md "# policy-as-code-opa-azure-poc\n\nPoC de Policy as Code com OPA/Rego para Azure (sanitized).\n"
write_if_empty CHANGELOG.md "# Changelog\n"
write_if_empty CODEOWNERS "# Ex.: * @seu-time\n"
write_if_empty .gitignore ".DS_Store\nterraform.tfstate\nterraform.tfstate.backup\n*.log\n"

write_if_empty policies/azure/tagging/require-tags/policy.rego "package azure.tagging.require_tags\n\ndefault deny := []\n"
write_if_empty policies/azure/tagging/require-tags/policy_test.rego "package azure.tagging.require_tags\n\n# tests\n"
write_if_empty policies/azure/tagging/require-tags/README.md "# Require Tags (Azure)\n"
write_if_empty examples/terraform/README.md "# Terraform examples\n"
write_if_empty docs/architecture.md "# Architecture\n"
write_if_empty docs/governance-model.md "# Governance model\n"
write_if_empty docs/policy-lifecycle.md "# Policy lifecycle\n"

write_if_empty .github/pull_request_template.md "## What\n-\n\n## Why\n-\n\n## How to test\n- [ ] opa test -v ./policies\n"

write_if_empty .github/workflows/ci.yml "name: CI\n\non:\n  pull_request:\n  push:\n    branches: [ \"main\" ]\n\njobs:\n  policy-tests:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n      - name: Install OPA\n        run: |\n          curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static\n          chmod +x opa\n          sudo mv opa /usr/local/bin/opa\n      - name: OPA tests\n        run: opa test -v ./policies\n"

write_if_empty .github/workflows/release-bundle.yml "name: Release Bundle\n\non:\n  push:\n    tags:\n      - \"v*.*.*\"\n\njobs:\n  bundle:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n      - name: Install OPA\n        run: |\n          curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static\n          chmod +x opa\n          sudo mv opa /usr/local/bin/opa\n      - name: Build bundle\n        run: |\n          mkdir -p dist\n          opa build -b ./policies -o dist/policies-bundle.tar.gz\n"

echo "OK: scaffold criado."
