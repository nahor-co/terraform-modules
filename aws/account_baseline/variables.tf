variable "email" {
  description = "AWS Account Admin Email. Will replace @ with +<account_name>"
  type        = string 
}

variable "organizational_unit_name" {
  description = "Name of organizational unit"
  type        = string
}

variable "accounts" {
  description = "Core accounts, see default or override"
  type        = list(string)
  default     = ["shared","logs","security"]
}

variable "close_on_deletion" {
  description = "(Optional) If true, a deletion event will close the account. Otherwise, it will only remove from the organization."
  type = bool
  default = true
}

variable "enabled_policy_types" {
  description = "List of Organizations policy types to enable in the Organization Root. e.g., AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY, SERVICE_CONTROL_POLICY, and TAG_POLICY"
  type        = list(string)
  default     = ["SERVICE_CONTROL_POLICY"]
}

variable "role_name" {
  description = "The name of an IAM role that Organizations automatically preconfigures in the new member account. This role trusts the master account, allowing users in the master account to assume the role, as permitted by the master account administrator. The role has administrator permissions in the new member account"
  type        = string
  default     = "admin"
}

variable "feature_set" {
  description = "(Optional) Specify ALL (default) or CONSOLIDATED_BILLING"
  type        = string
  default     = "ALL"
}

variable "iam_user_access_to_billing" {
  description = "(Optional) If set to ALLOW, the new account enables IAM users to access account billing information if they have the required permissions."
  type        = string
  default     = "DENY"
}

variable "allowed_regions" {
  description = "AWS Regions allowed for use (for use with the restrict regions SCP)"
  type        = list(string)
}
