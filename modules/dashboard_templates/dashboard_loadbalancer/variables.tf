variable "service" {
  type = string
}

variable "offset" {
  type = number
}

variable "display_requests_per_second" {
  type = bool
  default = true
}

variable "internal" {
  type = bool
  default = true
}