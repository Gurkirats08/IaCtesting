variable "key_vault_key_name" {
    type = string
    description = "Name of key vault key"
}

variable "key_vault_id" {  
    type        = string  
    description = "(Required) The ID of the Key Vault where the Key should be created."
}

variable "key_type" {  
    type        = string  
    description = "(Required) Specifies the Key Type to use for the Key Vault Key."
    validation {    
        condition = contains(["RSA", "RSA-HSM"], var.key_type)    
        error_message = "Key type must be 'RSA', 'RSA-HSM'."  
    }
}

variable "key_size" {  
    type        = number  
    description = "(Optional) Specifies the Size of the RSA key to create in bytes. Allowed values are 1024, 2048, 3072 or 4096."  
    default     = 4096  
    validation {    
        condition = contains([1024, 2048, 3072, 4096], var.key_size)    
        error_message = "Key size must be 1024, 2048, 3072 or 4096."  
    }
}

variable "not_before_date" {
    type        = string  
    description = "(Optional) Key not usable before the provided UTC datetime (Y-m-d'T'H:M:S'Z')."  
    default     = null
}

variable "expiration_date" {  
    type        = string  
    description = "(Optional) Expiration UTC datetime (Y-m-d'T'H:M:S'Z')."
    default = null
}

variable "key_opts" {  
    type        = list(string)  
    description = "(Required) A list of JSON web key operations. Possible values include: decrypt, encrypt, sign, unwrapKey, verify and wrapKey."
}

variable "rotation_policy" {
    type = object({    
        notify_before_expiry = string    
        time_before_expiry   = string    
        time_after_creation  = optional(string, null)    
        expire_after         = string  
    })  
    default = null
    description = <<EOT
    A rotation policy block as defined below  
    object ({    
        notify_before_expiry = "Expire a Key Vault Key after given duration as an ISO 8601 duration."    
        time_before_expiry   = "Rotate automatically at a duration before expiry as an ISO 8601 duration."    
        time_after_creation  = "Rotate automatically at a duration after create as an ISO 8601 duration."    
        expire_after         = "Expire a Key Vault Key after given duration as an ISO 8601 duration."  
    })  
    EOT
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}