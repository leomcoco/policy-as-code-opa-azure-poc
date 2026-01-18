package azure.tagging.require_tags

import rego.v1

test_deny_when_missing_tag if {
	input_data := {"resource": {"tags": {"ambiente": "prod"}}}

	denies := data.azure.tagging.require_tags.deny with input as input_data

	denies["Missing required tag: empresa"]
}

test_allow_when_all_tags_present if {
	input_data := {"resource": {"tags": {"ambiente": "prod", "empresa": "bradesco", "centro_de_custo": "123"}}}

	denies := data.azure.tagging.require_tags.deny with input as input_data

	count(denies) == 0
}
