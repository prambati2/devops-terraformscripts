resource "kubernetes_namespace" "n" {
  metadata {
    name = "deloitted-events-feed"
  }
}