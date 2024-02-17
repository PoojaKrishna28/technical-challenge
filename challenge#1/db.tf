#Create Random password 
resource "random_password" "randompassword" {
  length           = 16
  special          = true
}

#Create Key Vault Secret
resource "azurerm_key_vault_secret" "sqladminpassword" {
  name         = "sqladminpass"
  value        = random_password.randompassword.result
  key_vault_id = azurerm_key_vault.fg-keyvault.id
  content_type = "password"
}

resource "azurerm_key_vault_secret" "sqladminname" {
  name         = "sqladminnme"
  value        = "testadmin"
  key_vault_id = azurerm_key_vault.fg-keyvault.id
}

#Azure sql database
resource "azurerm_mssql_server" "azuresql" {
  name                         = "sqldb-dev"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "testadmin"
  administrator_login_password = random_password.randompassword.result

  azuread_administrator {
    login_username = "AAD Admin"
    object_id      = "xxxx-xxxxx"
  }
}

#add subnet from the backend vnet
#adding a new comment in main branch
resource "azurerm_mssql_virtual_network_rule" "allow-be" {
  name      = "be-sql-vnet-rule"
  server_id = azurerm_mssql_server.azuresql.id
  subnet_id = azurerm_subnet.be-subnet.id
  depends_on = [
    azurerm_mssql_server.azuresql
  ]
}

resource "azurerm_mssql_database" "fg-database" {
  name           = "fg-db"
  server_id      = azurerm_mssql_server.azuresql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

}
