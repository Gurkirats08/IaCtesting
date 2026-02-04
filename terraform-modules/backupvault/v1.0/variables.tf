  variable "backupvaultname" {
    type = string
    description = "The name of the Backup Vault"
  }

  # variable "backuppolicy" {
  #   type = string
  #   description = "The name of the Backup Policy Name"
  # }

  variable "resource_group_name" {
    type = string
    description = "The name of the resource group"
  }

  variable "location" {
    type = string
    description = "The location of the Backup Vault"
  }

  #  variable "blobname" {
  #   type = string
  #   description = "blobname"
  # }

   variable "redundancy" {
    type = string
    description = "The redundancy type for the backup vault"
  }

   variable "datastore_type" {
    type = string
    description = "The type of datastore used for the backup vault"
  }
  #   variable "operational_default_retention_duration" {
  #    type = string
  #    description = "The type of datastore used for the backup vault"
  # }
  //    variable "retention_duration" {
  //     type = string
  //     description = "The retention duration for the backup vault"
  //  }
