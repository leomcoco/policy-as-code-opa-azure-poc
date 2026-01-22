package azure.tagging.require_tags

import rego.v1

# Importante: "data" é o documento vindo do arquivo data.json nesta pasta
cfg := data.azure.tagging.require_tags.data.config.azure.tagging.require_tags

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

	has_nonempty(tags, "empresa")
	not regex.match(cfg.patterns.empresa, tags.empresa)

	msg := sprintf("%s (%s): tag empresa inválida: %q", [rc.address, rc.type, tags.empresa])
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)

	has_nonempty(tags, "app")
	not regex.match(cfg.patterns.app, tags.app)

	msg := sprintf("%s (%s): tag app inválida: %q", [rc.address, rc.type, tags.app])
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)

	has_nonempty(tags, "projeto")
	not regex.match(cfg.patterns.projeto, tags.projeto)

	msg := sprintf("%s (%s): tag projeto inválida: %q", [rc.address, rc.type, tags.projeto])
}

#################
# Helpers
#################

is_relevant_change(rc) if {
	rc.mode == "managed"
	rc.change.after != null
	not is_destroy(rc.change.actions)
}

is_destroy(actions) if {
	actions[_] == "delete"
}

has_tags_field(rc) if {
	after := rc.change.after
	object.get(after, "tags", null) != null
} else if {
	after := rc.change.after
	object.get(after, "tags_all", null) != null
}

get_tags(rc) := tags if {
	after := rc.change.after
	tags := object.get(after, "tags", object.get(after, "tags_all", {}))
}

missing_required(tags) := missing if {
	missing := [t |
		t := cfg.required[_]
		not has_nonempty(tags, t)
	]
}

has_nonempty(tags, k) if {
	v := object.get(tags, k, "")
	v != ""
}

allowed(arr, v) if {
	arr[_] == v
}
