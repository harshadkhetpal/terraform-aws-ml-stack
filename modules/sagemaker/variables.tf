variable "domain_name"       { type = string }
variable "project"           { type = string }
variable "vpc_id"            { type = string }
variable "private_subnet_ids"{ type = list(string) }
variable "data_bucket"       { type = string }
variable "tags"              { type = map(string); default = {} }
variable "feature_definitions" {
  type = list(object({ name = string; type = string }))
  default = [
    { name = "entity_id",   type = "String" },
    { name = "event_time",  type = "String" },
    { name = "feature_v1",  type = "Fractional" },
    { name = "feature_v2",  type = "Fractional" },
  ]
}
