package azure.tagging.require_tags

import rego.v1

data_for_tests := {
  "config": {
    "azure": {
      "tagging": {
        "require_tags": {
          "required": ["centro_de_custo", "app", "gerenciamento", "empresa", "ambiente", "projeto"],
          "allowed": {
            "ambiente": ["sandbox", "dev", "hom", "prod"],
            "gerenciamento": ["ti", "negocio", "terceiros"]
          },
          "patterns": {
            "centro_de_custo": "^[0-9]{4,10}$",
            "empresa": "^[a-z0-9][a-z0-9_-]{1,62}[a-z0-9]$",
            "app": "^[a-z0-9][a-z0-9-]{1,62}[a-z0-9]$",
            "projeto": "^[a-z0-9][a-z0-9-]{1,62}[a-z0-9]$"
          }
        }
      }
    }
  }
}

test_fail_missing_required_tags if {
  input := {
    "resource_changes": [
      {
        "address": "azurerm_resource_group.rg",
        "mode": "managed",
        "type": "azurerm_resource_group",
        "change": {
          "actions": ["create"],
          "after": {
            "tags": {
              "ambiente": "sandbox",
              "empresa": "poc"
            }
          }
        }
      }
    ]
  }

  denies := data.azure.tagging.require_tags.deny
    with input as input
    with data as data_for_tests

  count(denies) >= 1
}

test_fail_invalid_ambiente if {
  input := {
    "resource_changes": [
      {
        "address": "azurerm_resource_group.rg",
        "mode": "managed",
        "type": "azurerm_resource_group",
        "change": {
          "actions": ["create"],
          "after": {
            "tags": {
              "centro_de_custo": "1234",
              "app": "poc-opa",
              "gerenciamento": "ti",
              "empresa": "poc",
              "ambiente": "qa",
              "projeto": "opa-poc"
            }
          }
        }
      }
    ]
  }

  denies := data.azure.tagging.require_tags.deny
    with input as input
    with data as data_for_tests

  count(denies) >= 1
}

test_success_all_tags_valid if {
  input := {
    "resource_changes": [
      {
        "address": "azurerm_resource_group.rg",
        "mode": "managed",
        "type": "azurerm_resource_group",
        "change": {
          "actions": ["create"],
          "after": {
            "tags": {
              "centro_de_custo": "1234",
              "app": "poc-opa",
              "gerenciamento": "ti",
              "empresa": "poc",
              "ambiente": "sandbox",
              "projeto": "opa-poc"
            }
          }
        }
      }
    ]
  }

  denies := data.azure.tagging.require_tags.deny
    with input as input
    with data as data_for_tests

  count(denies) == 0
}

test_ignore_resource_without_tags_field if {
  input := {
    "resource_changes": [
      {
        "address": "azurerm_subnet.snet",
        "mode": "managed",
        "type": "azurerm_subnet",
        "change": {
          "actions": ["create"],
          "after": {
            "name": "snet"
          }
        }
      }
    ]
  }

  denies := data.azure.tagging.require_tags.deny
    with input as input
    with data as data_for_tests

  count(denies) == 0
}
