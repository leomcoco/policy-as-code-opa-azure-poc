package azure.tagging.require_tags

import rego.v1

cfg := data.azure.tagging.require_tags

# Saída padrão para Conftest/CI: lista de mensagens.
deny contains msg if {
  rc := input.resource_changes[_]
  is_relevant_change(rc)

  tags, ok := get_tags(rc)

  # Para PoC: só aplica em recursos que efetivamente expõem tags no plan
  cfg.enforce_only_when_tags_exist
  not ok

  # se não tem tags no schema do recurso, não bloqueia (evita falso positivo)
  false
}

deny contains msg if {
  rc := input.resource_changes[_]
  is_relevant_change(rc)

  tags, ok := get_tags(rc)
  ok

  missing := missing_required(tags)
  count(missing) > 0

  msg := sprintf("%s (%s): faltando tags obrigatórias: %v", [rc.address, rc.type, missing])
}

deny contains msg if {
  rc := input.resource_changes[_]
  is_relevant_change(rc)

  tags, ok := get_tags(rc)
  ok
  has_nonempty(tags, "owner")

  not regex.match(cfg.patterns.owner, tags.owner)

  msg := sprintf("%s (%s): tag owner inválida: %q (esperado e-mail)", [rc.address, rc.type, tags.owner])
}

deny contains msg if {
  rc := input.resource_changes[_]
  is_relevant_change(rc)

  tags, ok := get_tags(rc)
  ok
  has_nonempty(tags, "cost_center")

  not regex.match(cfg.patterns.cost_center, tags.cost_center)

  msg := sprintf("%s (%s): tag cost_center inválida: %q (esperado numérico)", [rc.address, rc.type, tags.cost_center])
}

deny contains msg if {
  rc := input.resource_changes[_]
  is_relevant_change(rc)

  tags, ok := get_tags(rc)
  ok
  has_nonempty(tags, "ambiente")

  env := lower(tags.ambiente)
  not allowed(cfg.allowed.ambiente, env)

  msg := sprintf("%s (%s): tag ambiente inválida: %q (permitidos: %v)", [rc.address, rc.type, tags.ambiente, cfg.allowed.ambiente])
}

deny contains msg if {
  rc := input.resource_changes[_]
  is_relevant_change(rc)

  tags, ok := get_tags(rc)
  ok
  has_nonempty(tags, "squad")

  # Se lista estiver vazia, não valida (facilita PoC evolutiva)
  count(cfg.allowed.squad) > 0
  not allowed(cfg.allowed.squad, tags.squad)

  msg := sprintf("%s (%s): tag squad inválida: %q (permitidos: %v)", [rc.address, rc.type, tags.squad, cfg.allowed.squad])
}

##########
# Helpers
##########

is_relevant_change(rc) {
  rc.mode == "managed"
  rc.change.after != null
  not is_destroy(rc.change.actions)
}

is_destroy(actions) {
  actions[_] == "delete"
}

# Retorna (tags, ok). ok=false quando recurso não expõe tags no plan (ex.: subnet).
get_tags(rc) = (tags, ok) {
  after := rc.change.after
  tags := object.get(after, "tags", object.get(after, "tags_all", {}))
  ok := count(tags) >= 0
  # ok real: campo existia?
  ok := object.get(after, "tags", null) != null or object.get(after, "tags_all", null) != null
}

missing_required(tags) = missing {
  required := cfg.required
  missing := [t | t := required[_]; not has_nonempty(tags, t)]
}

has_nonempty(tags, k) {
  v := object.get(tags, k, "")
  v != ""
}

allowed(arr, v) {
  arr[_] == v
}
