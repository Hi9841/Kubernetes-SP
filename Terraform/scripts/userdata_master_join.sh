cat << 'EOF' > /usr/local/bin/update-ssm-join.sh
#!/bin/bash
set -euo pipefail

AwsRegion="us-east-1"
SsmJoinCpParam="/k8s/NachHi/Join/ControlPlane"
SsmJoinWorkerParam="/k8s/NachHi/Join/Worker"

CertKey=$(kubeadm init phase upload-certs --upload-certs | tail -n 1)
WorkerJoinCommand=$(kubeadm token create --print-join-command)
ControlPlaneJoinCommand="${WorkerJoinCommand} --control-plane --certificate-key ${CertKey}"

aws ssm put-parameter \
  --name "${SsmJoinWorkerParam}" \
  --type "SecureString" \
  --overwrite \
  --value "${WorkerJoinCommand}" \
  --region "${AwsRegion}"

aws ssm put-parameter \
  --name "${SsmJoinCpParam}" \
  --type "SecureString" \
  --overwrite \
  --value "${ControlPlaneJoinCommand}" \
  --region "${AwsRegion}"

EOF

chmod +x /usr/local/bin/update-ssm-join.sh

echo "*/5 * * * * /usr/local/bin/update-ssm-join.sh" | crontab -