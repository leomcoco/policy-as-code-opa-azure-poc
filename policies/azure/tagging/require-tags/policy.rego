package azure.tagging.require_tags

import rego.v1

# ajuste para os tags que você quer exigir
required_tags := {"ambiente", "empresa", "centro_de_custo"}

deny contains msg if {
  tags := object.get(input.resource, "tags", {})

  some tag in required_tags
  not tags[tag]

  msg := sprintf("Missing required tag: %s", [tag])
}
