resource "aws_iam_role" "control_plane_role" {
  name               = "NachHi-ControlPlane-Role"
  assume_role_policy = file("${path.module}/policyjsons/TrustPolicy.json")
} # Create the Role 

resource "aws_iam_policy" "control_plane_policy" {
  name   = "NachHi-ControlPlane-Policy"
  policy = file("${path.module}/policyjsons/NachHi-ControlPlane-Policy.json")
} # Create the Policy

resource "aws_iam_role_policy_attachment" "control_plane_attach" {
  role       = aws_iam_role.control_plane_role.name
  policy_arn = aws_iam_policy.control_plane_policy.arn
} # Attach The Policy

resource "aws_iam_instance_profile" "control_plane_profile" {
  name = "NachHi-ControlPlane-Profile"
  role = aws_iam_role.control_plane_role.name
} # Create Instance Profile With Said Role

resource "aws_iam_role" "worker_role" {
  name               = "NachHi-Worker-Role"
  assume_role_policy = file("${path.module}/policyjsons/TrustPolicy.json")
} # Create the Role 

resource "aws_iam_policy" "worker_policy" {
  name   = "NachHi-Worker-Policy"
  policy = file("${path.module}/policyjsons/NachHi-Worker-Policy.json")
} # Create the Policy

resource "aws_iam_role_policy_attachment" "worker_attach" {
  role       = aws_iam_role.worker_role.name
  policy_arn = aws_iam_policy.worker_policy.arn
} # Attach The Policy

resource "aws_iam_instance_profile" "worker_profile" {
  name = "NachHi-Worker-Profile"
  role = aws_iam_role.worker_role.name
} # Create Instance Profile With Said Role