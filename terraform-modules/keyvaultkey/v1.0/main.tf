resource "azurerm_key_vault_key" "this" {  
    name            = var.key_vault_key_name
    key_vault_id    = var.key_vault_id  
    key_type        = var.key_type  
    key_size        = var.key_size  
    expiration_date = var.expiration_date  
    key_opts        = var.key_opts  
    not_before_date = var.not_before_date  
    tags = var.tags
    dynamic rotation_policy {  
        for_each = var.rotation_policy != null ?  [var.rotation_policy] : []
        content {
            expire_after         = var.rotation_policy.expire_after    
            notify_before_expiry = var.rotation_policy.notify_before_expiry 
            automatic {      
                time_before_expiry  = var.rotation_policy.time_before_expiry      
                time_after_creation = var.rotation_policy.time_after_creation    
            } 
        }  
    }
}