variable "private_subnet_ids" {
  type = list(string)
  description = "List of private subnet IDs"
  default = []
}

variable "cluster_name" {
  type = string
  default = "uat-cluster"   
 }