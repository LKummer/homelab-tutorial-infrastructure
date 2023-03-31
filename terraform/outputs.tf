output "ssh_ip" {
  value       = module.tutorial.ip
  description = "IP of the created virtual machine."
}

output "ssh_user" {
  value       = module.tutorial.user
  description = "Name of user created by Cloud Init."
}
