helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install the stack (creates the namespace automatically)
helm install prom-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  -f values.yaml



helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install blackbox-exporter prometheus-community/prometheus-blackbox-exporter -n monitoring
