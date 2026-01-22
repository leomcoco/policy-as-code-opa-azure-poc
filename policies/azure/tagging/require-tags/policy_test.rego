package azure.tagging.require_tags

import rego.v1

test_fail_missing_required_tags if {
	input_fail := {"resource_changes": [{
		"address": "azurerm_resource_group.rg",
		"type": "azurerm_resource_group",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {
				"name": "rg-poc",
				"location": "brazilsouth",
				"tags": {
					"ambiente": "sandbox",
					"empresa": "poc",
				},
			},
		},
	}]}

	denies := data.azure.tagging.require_tags.deny with input as input_fail with data as data_for_tests
	count(denies) >= 1
}

test_success_all_tags_valid if {
	input_ok := {"resource_changes": [{
		"address": "azurerm_network_security_group.nsg",
		"type": "azurerm_network_security_group",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {
				"name": "nsg-poc",
				"location": "brazilsouth",
				"tags": {
					"centro_de_custo": "1234",
					"app": "opa-poc",
					"gerenciamento": "cloud-governance",
					"empresa": "poc",
					"ambiente": "sandbox",
					"projeto": "policy-as-code",
				},
			},
		},
	}]}

	denies := data.azure.tagging.require_tags.deny with input as input_ok with data as data_for_tests
	count(denies) == 0
}

test_ignore_resource_without_tags_field if {
	input_ignore := {"resource_changes": [{
		"address": "azurerm_subnet.subnet",
		"type": "azurerm_subnet",
		"mode": "managed",
		"change": {
			"actions": ["create"],
			"after": {"name": "subnet-poc"},
		},
	}]}

	denies := data.azure.tagging.require_tags.deny with input as input_ignore with data as data_for_tests
	count(denies) == 0
}

data_for_tests := {"config": {"azure": {"tagging": {"require_tags": {
	"required": [
		"centro_de_custo",
		"app",
		"gerenciamento",
		"empresa",
		"ambiente",
		"projeto",
	],
	"allowed": {"ambiente": ["sandbox", "dev", "hom", "prod"]},
	"patterns": {
		"centro_de_custo": "^[0-9]{4,10}$",
		"app": "^[a-zA-Z0-9][a-zA-Z0-9._-]{1,62}$",
		"gerenciamento": "^[a-zA-Z0-9][a-zA-Z0-9._-]{1,62}$",
		"empresa": "^[a-zA-Z0-9][a-zA-Z0-9._-]{1,62}$",
		"projeto": "^[a-zA-Z0-9][a-zA-Z0-9._-]{1,62}$",
	},
	"enforce_only_when_tags_exist": true,
}}}}}
