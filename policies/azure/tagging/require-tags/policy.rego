package azure.tagging.require_tags

required_tags := {"ambiente", "centro_de_custo"}

deny[msg] {
  tags := object.get(input.resource, "tags", {})
  t := required_tags[_]
  not tags[t]
  msg := sprintf("Missing required tag: %s", [t])
}
