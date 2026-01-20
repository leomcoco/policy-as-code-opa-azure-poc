variable "prefix" {
  description = "Prefixo para nomes dos recursos"
  type        = string
  default     = "poc-opa"
}

variable "location" {
  description = "Regiao Azure"
  type        = string
  default     = "brazilsouth"
}

variable "tags" {
  description = "Tags padrao"
  type        = map(string)
  default = {
    ambiente = "sandbox"
    empresa  = "poc"
  }
}
