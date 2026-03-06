output "control_plane_profile_name" {
  value = aws_iam_instance_profile.control_plane_profile.name
}

output "worker_profile_name" {
  value = aws_iam_instance_profile.worker_profile.name
}