output "ssh_connection" {
    description = "SSH connection command"
    value       = "ssh -i ${var.ssh_key_path} root@${module.compute.ipv4_address}"
}
