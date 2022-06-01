

resource "azurerm_policy_definition" "allowedlocations" {
  name                = "allowedlocations"
  mode                = "Indexed"
  policy_type         = "Custom"
  display_name        = "Allowed Locations"
  description         = "This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the 'global' region."
  management_group_id = data.azurerm_management_group.root.id
  metadata            = <<METADATA
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
            "field": "location",
            "notIn": ["northeurope", "westeurope"]
          },
          {
            "field": "location",
            "notEquals": "global"
          },
          {
            "field": "type",
            "notEquals": "Microsoft.AzureActiveDirectory/b2cDirectories"
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

output "allowedlocations-Naming_id" {
  value       = azurerm_policy_definition.allowedlocations.id
  description = "This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the 'global' region."
}




resource "azurerm_policy_definition" "allowedresourcegroupslocations" {
  name                = "allowedresourcegroupslocations"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "Allowed Resource Groups Locations"
  description         = "This policy enables you to restrict the locations your organization can specify when deploying resource groups. Use to enforce your geo-compliance requirements."
  management_group_id = data.azurerm_management_group.root.id
  metadata            = <<METADATA
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
            "equals": "Microsoft.Resources/subscriptions/resourceGroups"
          },
          {
            "field": "location",
            "notIn": ["northeurope", "westeurope"]
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

output "allowedresourcegrouplocations-Naming_id" {
  value       = azurerm_policy_definition.allowedresourcegroupslocations.id
  description = "This policy enables you to restrict the locations your organization can specify when deploying resource groups. Use to enforce your geo-compliance requirements."
}