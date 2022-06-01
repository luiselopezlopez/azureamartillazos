resource "azurerm_policy_definition" "ResourceGroup_Naming" {
  name                = "ResourceGroup_Naming"
  policy_type         = "Custom"
  mode                = "All"
  display_name        = "Resource Group Naming Convention"
  description         = "This policy check if the name of the resource groups is compliant"
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
            "equals": "Microsoft.Resources/subscriptions/ResourceGroups"
            },
            {
              "not": {
                "field": "name",
                "like": "RG-WEU-*"
              } 
            },
            {
              "not":{
                "field": "name",
                "like": "RG-NEU-*"
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
  value       = azurerm_policy_definition.ResourceGroup_Naming.id
  description = "The policy definition for Resource Group Naming Convention"
}
