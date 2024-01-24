output "result" {
  description = "Test description output"
  value       = random_id.foo.id
}

output "sensitive_value" {
  description = "Test sensitive description output"
  value       = random_id.foo.id
  sensitive   = true
}