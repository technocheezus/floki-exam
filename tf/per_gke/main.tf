# main.tf
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Provider configuration
provider "kubernetes" {
  # Kubernetes provider configuration
  # If using minikube, this can be left empty
  # For other clusters, configure accordingly
}

provider "helm" {
  kubernetes {
    # Helm provider configuration
    # If using minikube, this can be left empty
    # For other clusters, configure accordingly
  }
}

# Create namespace for ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Install ArgoCD using Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.8"  # Specify the version you want to use
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [kubernetes_namespace.argocd]
}

# Optional: Create an ingress for ArgoCD
# Uncomment if needed
/*
resource "kubernetes_ingress_v1" "argocd" {
  metadata {
    name      = "argocd-ingress"
    namespace = kubernetes_namespace.argocd.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      # Add other annotations as needed
    }
  }

  spec {
    rule {
      host = "argocd.example.com"  # Replace with your domain
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
*/

# values.yaml file for ArgoCD configuration
resource "local_file" "argocd_values" {
  filename = "${path.module}/values.yaml"
  content  = <<-EOF
# ArgoCD Helm values
server:
  extraArgs:
    - --insecure # Remove in production
  service:
    type: LoadBalancer # Change to ClusterIP if using Ingress

  # Configure authentication
  config:
    admin.enabled: true
    url: https://argocd.example.com  # Replace with your domain

# Configure RBAC
rbac:
  defaultPolicy: 'role:readonly'

# Configure notifications
notifications:
  enabled: true

# Configure High Availability
controller:
  replicas: 1  # Increase for HA

redis:
  enabled: true

# Configure repositories
repos:
  - url: https://github.com/yourusername/your-repo
    name: my-apps
    type: git
    # Add credentials if needed
    # username: git
    # password: <password>

# Configure SSO (Optional)
# dex:
#   enabled: true
#   config:
#     connectors:
#     - type: github
#       id: github
#       name: GitHub
#       config:
#         clientID: your-client-id
#         clientSecret: your-client-secret
#         orgs:
#         - name: your-github-org
EOF
}

# outputs.tf
output "argocd_namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_server_service" {
  value = "kubectl get svc argocd-server -n ${kubernetes_namespace.argocd.metadata[0].name}"
}

# variables.tf
variable "argocd_version" {
  description = "Version of ArgoCD to install"
  type        = string
  default     = "5.46.8"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}