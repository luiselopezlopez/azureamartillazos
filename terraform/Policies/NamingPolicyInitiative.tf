resource "azurerm_policy_set_definition" "AzureNaming" {
  name                  = "AzureNaming"
  policy_type           = "Custom"
  display_name          = "Azure Naming Policy"
  management_group_id   = data.azurerm_management_group.root.id  

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.ResourceGroup_Naming.id
  }

  
  metadata            = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
    METADATA
}

resource "azurerm_management_group_policy_assignment" "AzureNamingInitiative" {
    name = "Azure Naming"    
    policy_definition_id = azurerm_policy_set_definition.AzureNaming.id
    management_group_id = data.azurerm_management_group.root.id
}

