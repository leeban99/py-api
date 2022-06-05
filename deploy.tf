terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "kubernetes_deployment" "API" {
  metadata {
    name = "sum-api"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "sum-api"
      }
    }
    template {
      metadata {
        labels = {
          app = "sum-api"
        }
      }
      spec {
        container {
          image = "leeban99/math_operations:base"
          name  = "math-operations"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "API" {
  metadata {
    name      = "sum-api"
  }
  spec {
    selector = {
      app = kubernetes_deployment.API.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      node_port   = 30080
      port        = 80
      target_port = 80
    }
  }
}

output "endpoint" {
    value = kubernetes_service.API.spec
  
}
