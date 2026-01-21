package azure.tagging.require_tags

import rego.v1

cfg := data.azure.tagging.require_tags

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)

	# Para evitar falso positivo: só aplica se o recurso expõe tags no plan
	cfg.enforce_only_when_tags_exist
	not has_tags_field(rc)

	# Se não tem campo tags/tags_all no plan, não bloqueia (ex.: subnet)
	false
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)

	missing := missing_required(tags)
	count(missing) > 0

	msg := sprintf(
		"%s (%s): faltando tags obrigatórias: %v",
		[rc.address, rc.type, missing],
	)
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)
	has_nonempty(tags, "owner")

	not regex.match(cfg.patterns.owner, tags.owner)

	msg := sprintf(
		"%s (%s): tag owner inválida: %q (esperado e-mail)",
		[rc.address, rc.type, tags.owner],
	)
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)
	has_nonempty(tags, "cost_center")

	not regex.match(cfg.patterns.cost_center, tags.cost_center)

	msg := sprintf(
		"%s (%s): tag cost_center inválida: %q (esperado numérico)",
		[rc.address, rc.type, tags.cost_center],
	)
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)
	has_nonempty(tags, "ambiente")

	env := lower(tags.ambiente)
	not allowed(cfg.allowed.ambiente, env)

	msg := sprintf(
		"%s (%s): tag ambiente inválida: %q (permitidos: %v)",
		[rc.address, rc.type, tags.ambiente, cfg.allowed.ambiente],
	)
}

deny contains msg if {
	rc := input.resource_changes[_]
	is_relevant_change(rc)
	has_tags_field(rc)

	tags := get_tags(rc)
	has_nonempty(tags, "squad")

	count(cfg.allowed.squad) > 0
	not allowed(cfg.allowed.squad, tags.squad)

	msg := sprintf(
		"%s (%s): tag squad inválida: %q (permitidos: %v)",
		[rc.address, rc.type, tags.squad, cfg.allowed.squad],
	)
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
	required := cfg.required
	missing := [t | t := required[_]; not has_nonempty(tags, t)]
}

has_nonempty(tags, k) if {
	v := object.get(tags, k, "")
	v != ""
}

allowed(arr, v) if {
	arr[_] == v
}
