resource "kubernetes_deployment" "deloitted-internal-events-feed-deployment" {
  metadata {
    name = "deloitted-internal-events-feed-deployment"
    labels = {
      App = "deloitted-internal-events-feed"
    }
    namespace = kubernetes_namespace.n.metadata[0].name
  }

  spec {
    replicas                  = 1
    progress_deadline_seconds = 60
    selector {
      match_labels = {
        App = "deloitted-internal-events-feed"
      }
    }
    template {
      metadata {
        labels = {
          App = "deloitted-internal-events-feed"
        }
      }
      spec {
        container {
          image = "gcr.io/mar-roidtc315/internal-image:v1.0.0"
          name  = "deloitted-internal-events-feed"

          port {
            container_port = 8082
          }

          resources {
            limits = {
              cpu    = "0.2"
              memory = "2562Mi"
            }
            requests = {
              cpu    = "0.1"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}