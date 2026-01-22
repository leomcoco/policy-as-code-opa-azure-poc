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
    centro_de_custo = "1234"
    app             = "poc-opa"
    gerenciamento   = "ti"
    empresa         = "poc"
    ambiente        = "sandbox"
    projeto         = "opa-poc"
  }

}
