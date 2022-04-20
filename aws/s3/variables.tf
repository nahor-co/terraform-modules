variable "bucket" {
  description = "Name of bucket"
  type        = string
}
  
variable "force_destroy" {
  description = "Does bucket require force_destroy"
  type        = bool
  default     = false
} 

variable "acl" {
  description = "Bucket access control list"
  type        = string
  default     = "private"
  validation {
    condition = contains([
      "private", "public-read", "public-read-write", "authenticated-read", "aws-exec-read", "log-delivery-write"
    ], var.acl)
    error_message = "Expected acl to be one of [private public-read public-read-write authenticated-read aws-exec-read log-delivery-write]."
  }
}