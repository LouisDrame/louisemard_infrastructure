# Hetzner server configuration variables
variable "server_image" {
    type = string
    description = "Image for all servers"
    default = "ubuntu-24.04"
}

variable servers {
    type = map(object({
        name     = string
        type     = string
        location = string
        labels   = map(string)
    }))
    description = "Map of server configurations"
}

variable "ssh_key_path" {
    type = string
    description = "Path to the SSH public key to be added to the server"
}