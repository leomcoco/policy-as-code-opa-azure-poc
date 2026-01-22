package azure.tagging.require_tags

import rego.v1

cfg_doc := {"config": {"azure": {"tagging": {"require_tags": {
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
		"empresa": "^[a-z0-9][a-z0-9_-]{1,62}[a-z0-9]$",
		"app": "^[a-z0-9][a-z0-9-]{1,62}[a-z0-9]$",
		"projeto": "^[a-z0-9][a-z0-9-]{1,62}[a-z0-9]$",
	},
	"enforce_only_when_tags_exist": true,
}}}}}

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
					"empresa": "poc",
					"ambiente": "sandbox",
				},
			},
		},
	}]}

	denies := data.azure.tagging.require_tags.deny with input as input_fail
		with data.azure.tagging.require_tags.data as cfg_doc

	count(denies) >= 1
}

test_fail_invalid_ambiente if {
	input_bad := {"resource_changes": [{
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
					"app": "poc-opa",
					"gerenciamento": "ti",
					"empresa": "poc",
					"ambiente": "qa",
					"projeto": "opa-poc",
				},
			},
		},
	}]}

	denies := data.azure.tagging.require_tags.deny with input as input_bad
		with data.azure.tagging.require_tags.data as cfg_doc

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
					"app": "poc-opa",
					"gerenciamento": "ti",
					"empresa": "poc",
					"ambiente": "sandbox",
					"projeto": "opa-poc",
				},
			},
		},
	}]}

	denies := data.azure.tagging.require_tags.deny with input as input_ok
		with data.azure.tagging.require_tags.data as cfg_doc

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

	denies := data.azure.tagging.require_tags.deny with input as input_ignore
		with data.azure.tagging.require_tags.data as cfg_doc

	count(denies) == 0
}
