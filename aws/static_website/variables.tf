variable "domain" {
  description = "Name of domain (eg nahor.co.uk)"
  type        = string
}

variable "hosted_zone_name" {
  description = "Name of hosted zone. Defaults to that of var.domain."
  type = string
  default = ""
}

variable "root_object" {
  description = "The object you want returned when user requests the root URL"
  type        = string
  default     = "index.html"
}

variable "force_destroy" {
  description = "(Optional, Default:false) A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type    = bool
  default = false
}
