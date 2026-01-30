resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.0.0" # Lock version for stability
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  set {
    name  = "server.service.type"
    value = "LoadBalancer" # Expose via LoadBalancer for easy access (use Ingress for prod)
  }
  
  # Ensure EKS node groups are ready before installing
  depends_on = [module.eks] 
}

output "argocd_server_host" {
    value = "Run 'kubectl get svc -n argocd' to see the external IP"
}
