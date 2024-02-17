#Frontend
resource "azurerm_linux_web_app" "fe-webapp" {
  name                  = "demoapp123"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.fe-asp.id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
    always_on = true

    application_stack {
      node_version = "16-lts"
    }
  }
  
  app_settings = {

    "key"                  = value
  }

}

#Backend
#storage account for functionapp
resource "azurerm_storage_account" "fa-storageaccount" {
  name                     = "stfuncapp123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_function_app" "be-fnapp" {
  name                = "be-function-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.fa-storageaccount.name
  storage_account_access_key = azurerm_storage_account.fa-storageaccount.primary_access_key
  service_plan_id            = azurerm_service_plan.be-asp.id
  

  app_settings = {
     "key" = value 
  }

  site_config {

  ip_restriction {
          virtual_network_subnet_id = azurerm_subnet.fe-subnet.id
          priority = 100
          name = "Frontend access only"
           }
  application_stack {
      python_version = 3.8
    }
  }

  identity {
  type = "SystemAssigned"
   }

 depends_on = [
   azurerm_storage_account.fa-storageaccount
 ]
}

#vnet integration of frontend functions
resource "azurerm_app_service_virtual_network_swift_connection" "fe-vnet-integration" {
  app_service_id = azurerm_linux_web_app.fe-webapp.id
  subnet_id      = azurerm_subnet.frontend-subnet.id

  depends_on = [
    azurerm_linux_web_app.fe-webapp
  ]
}

#vnet integration of backend functions
resource "azurerm_app_service_virtual_network_swift_connection" "be-vnet-integration" {
  app_service_id = azurerm_linux_function_app.be-fnapp.id
  subnet_id      = azurerm_subnet.backend-subnet.id
  depends_on = [
    azurerm_linux_function_app.be-fnapp
  ]
}

