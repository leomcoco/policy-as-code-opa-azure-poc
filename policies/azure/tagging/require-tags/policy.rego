package azure.tagging.require_tags

import rego.v1

cfg := data.config.azure.tagging.require_tags

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)
	missing := missing_required(tags)
	count(missing) > 0

	msg := sprintf("%s (%s): faltando tags obrigatórias: %v", [rc.address, rc.type, missing])
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)
	has_nonempty(tags, "centro_de_custo")
	not regex.match(cfg.patterns.centro_de_custo, tags.centro_de_custo)

	msg := sprintf("%s (%s): tag centro_de_custo inválida: %q (esperado numérico 4-10 dígitos)", [rc.address, rc.type, tags.centro_de_custo])
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)
	has_nonempty(tags, "ambiente")

	env := lower(tags.ambiente)
	not allowed(cfg.allowed.ambiente, env)

	msg := sprintf("%s (%s): tag ambiente inválida: %q (permitidos: %v)", [rc.address, rc.type, tags.ambiente, cfg.allowed.ambiente])
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)
	has_nonempty(tags, "gerenciamento")

	g := lower(tags.gerenciamento)
	count(cfg.allowed.gerenciamento) > 0
	not allowed(cfg.allowed.gerenciamento, g)

	msg := sprintf("%s (%s): tag gerenciamento inválida: %q (permitidos: %v)", [rc.address, rc.type, tags.gerenciamento, cfg.allowed.gerenciamento])
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)
	has_nonempty(tags, "empresa")
	not regex.match(cfg.patterns.empresa, tags.empresa)

	msg := sprintf("%s (%s): tag empresa inválida: %q (padrão: %s)", [rc.address, rc.type, tags.empresa, cfg.patterns.empresa])
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)
	has_nonempty(tags, "app")
	not regex.match(cfg.patterns.app, tags.app)

	msg := sprintf("%s (%s): tag app inválida: %q (padrão: %s)", [rc.address, rc.type, tags.app, cfg.patterns.app])
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)
	has_nonempty(tags, "projeto")
	not regex.match(cfg.patterns.projeto, tags.projeto)

	msg := sprintf("%s (%s): tag projeto inválida: %q (padrão: %s)", [rc.address, rc.type, tags.projeto, cfg.patterns.projeto])
}

# ----------------
# Helpers
# ----------------

is_relevant_change(rc) if {
	rc.mode == "managed"
	not startswith(rc.address, "data.")
	not is_delete(rc)
	has_after(rc)
}

is_delete(rc) if rc.change.actions[_] == "delete"

has_after(rc) if rc.change.after != null

has_tags_field(rc) if {
	after := rc.change.after
	object.get(after, "tags", null) != null
}

has_tags_field(rc) if {
	after := rc.change.after
	object.get(after, "tags_all", null) != null
}

get_tags(rc) := tags if {
	tags := object.get(rc.change.after, "tags", null)
	tags != null
}

get_tags(rc) := tags if {
	tags := object.get(rc.change.after, "tags_all", {})
}

has_nonempty(tags, k) if {
	v := object.get(tags, k, "")
	v != ""
}

missing_required(tags) := missing if {
	missing := [t | t := cfg.required[_]; not has_nonempty(tags, t)]
}

allowed(list, v) if {
	list[_] == v
}
