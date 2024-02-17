resource "azurerm_resource_group" "rg" {
  name     = "demo-rg"
  location = var.location
  tags = {
    "Environment" = "Development"
  }
}
