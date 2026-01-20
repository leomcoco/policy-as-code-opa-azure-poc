provider "azurerm" {
  features {}

  # substitui skip_provider_registration (deprecated)
  # "none" = não tentar registrar Resource Providers automaticamente
  resource_provider_registrations = "none"
}
