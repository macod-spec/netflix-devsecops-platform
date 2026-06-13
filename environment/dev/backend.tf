terraform {
  backend "azurerm" {
    resource_group_name  = "rg-netflix-tfstate-uksouth"
    storage_account_name = "tfstatenetflixmac01"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
    use_azuread_auth     = true
  }
}
