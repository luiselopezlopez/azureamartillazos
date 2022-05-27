terraform {
  backend "azurerm" {
    resource_group_name  = "neu-rg-terraformstates"
    storage_account_name = "neustterraformstates"
    container_name       = "states"
    key                  = "azmpolicies.tfstate"
  }
}

provider "azurerm" {
  features {}
}


variable "policy_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
  default     = "Custom"
}

resource "azurerm_policy_definition" "ResourceGroup_Naming" {
  name         = "ResourceGroup_Naming"  
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Resource Group Naming Convention"
  description  = "This policy check if the name of the resource groups is compliant"
  management_group_id = "b267e754-ae0a-4daa-b217-c857813bf721"
  metadata = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
        "allOf": [
            {
            "field": "type",
            "equals": "Microsoft.Resources/subscriptions/ResourceGroups"
            },
            {
            "not": {
                "anyOf": [
                {
                    "field": "name",
                    "like": "RG-*-###"
                },
                {
                    "field": "name",
                    "match": " RG-*-###"
                }
                ]
            }
            }
        ]
        },
        "then": {
        "effect": "deny"
        }
    }
POLICY_RULE


  parameters = <<PARAMETERS
    {
    }
  
PARAMETERS

}

output "ResourceGroup-Naming_id" {
  value       = "${azurerm_policy_definition.ResourceGroup_Naming.id}"
  description = "The policy definition id for auditRoleAssignmentType_user"
}

