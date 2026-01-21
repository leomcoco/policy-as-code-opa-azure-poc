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
					"owner": "leo@empresa.com",
					"ambiente": "sandbox",
				},
			},
		},
	}]}

	denies := data.azure.tagging.require_tags.deny with input as input_fail
		with data as data_for_tests

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
					"owner": "leo@empresa.com",
					"cost_center": "1234",
					"ambiente": "sandbox",
					"squad": "squad-a",
				},
			},
		},
	}]}

	denies := data.azure.tagging.require_tags.deny with input as input_ok
		with data as data_for_tests

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
		with data as data_for_tests

	count(denies) == 0
}

data_for_tests := {"azure": {"tagging": {"require_tags": {
	"required": ["owner", "cost_center", "ambiente", "squad"],
	"allowed": {
		"ambiente": ["sandbox", "dev", "hom", "prod"],
		"squad": ["squad-a", "squad-b"],
	},
	"patterns": {
		"owner": "^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$",
		"cost_center": "^[0-9]{4,10}$",
	},
	"enforce_only_when_tags_exist": true,
}}}}
