package azure.tagging.require_tags

default deny := []

required_tags := {"ambiente", "centro_de_custo"}

deny[msg] {
  tags := object.get(input.resource, "tags", {})
  some t
  t := required_tags[_]
  not tags[t]
  msg := sprintf("Missing required tag: %s", [t])
}
