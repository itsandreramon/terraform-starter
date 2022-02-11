variable "region" {
  type = string
}

variable "type" {
  type = string
}

variable "name" {
  type = string
}

variable "ami" {
  type = string
}

variable "exec" {
  type = list(string)
}

variable "username" {
  type = string
}

variable "key_name" {
  type = string
}

variable "pem_file" {
  type = string
}

variable "port" {
  type = number
}

variable "port_db" {
  type = number
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}
