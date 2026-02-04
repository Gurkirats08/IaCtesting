variable "name" {
  description = "Name of the PostgreSQL database"
  type        = string

}

variable "location" {
  description = "Location of the PostgreSQL database"
  type        = string

}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string

}

variable "server_name" {
  description = "Name of the PostgreSQL server"
  type        = string

}

variable "charset" {
  description = "Character set for the PostgreSQL database"
  type        = string

}

variable "collation" {
  description = "Collation for the PostgreSQL database"
  type        = string
}