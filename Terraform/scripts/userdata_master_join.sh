cat << 'EOF' > /usr/local/bin/update-ssm-join.sh
#!/bin/bash
set -euo pipefail

AwsRegion="us-east-1"
SsmJoinCpParam="/k8s/NachHi/Join/ControlPlane"
SsmJoinWorkerParam="/k8s/NachHi/Join/Worker"

TimestampStr=$(aws ssm describe-parameters \
    --region "${AwsRegion}" \
    --parameter-filters "Key=Name,Values=${SsmJoinCpParam}" \
    --query "Parameters[0].LastModifiedDate" \
    --output text)

if [ "$TimestampStr" != "None" ] && [ -n "$TimestampStr" ]; then
    LastModified=$(date -d "$TimestampStr" +%s)
    CurrentTime=$(date +%s)
    Age=$((CurrentTime - LastModified))
else
    # If the parameter doesn't exist we set age to a high number to force the first update
    Age=9999
fi

# Only run your original logic if the parameter is older than 120 seconds
if [ "$Age" -gt 120 ]; then
    echo "Parameter is $Age seconds old. Updating now..."

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
else
    echo "Parameter is only $Age seconds old. Skipping update."
fi

EOF

chmod +x /usr/local/bin/update-ssm-join.sh

echo "*/5 * * * * /usr/local/bin/update-ssm-join.sh" | crontab -