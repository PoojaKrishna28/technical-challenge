resource "azurerm_service_plan" "fe-asp" {
  name                = "fe-asp-dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
  depends_on = [
    azurerm_subnet.frontend-subnet
  ]
}



resource "azurerm_service_plan" "be-asp" {
  name                = "be-asp-dev"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
  depends_on = [
    azurerm_subnet.backend-subnet
  ]
}
