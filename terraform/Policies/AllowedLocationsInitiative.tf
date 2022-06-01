resource "azurerm_policy_set_definition" "allowedlocations" {
  name                  = "AllowedLocations"
  policy_type           = "Custom"
  display_name          = "Allowed Locations"
  management_group_id   = data.azurerm_management_group.root.id  

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.allowedlocations.id
  }
  
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.allowedresourcegroupslocations.id
  }
  
  metadata            = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
    METADATA
}

resource "azurerm_management_group_policy_assignment" "AllowedLocationsInitiative" {
    name = "Allowed Locations"    
    policy_definition_id = azurerm_policy_set_definition.allowedlocations.id
    management_group_id = data.azurerm_management_group.root.id
}

