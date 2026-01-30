resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "56.0.0" # Lock version for stability
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  # Basic configuration
  set {
    name  = "grafana.enabled"
    value = "true"
  }
  
  # Expose Grafana via LoadBalancer for easy access (use Ingress for prod)
  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  depends_on = [module.eks] 
}

output "grafana_access_command" {
  value = "kubectl get svc -n monitoring kube-prometheus-stack-grafana"
}
