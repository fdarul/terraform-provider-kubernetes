resource "kubernetes_replication_controller" "redis" {
  metadata {
    name = "redis"
    labels {
      name = "redis"
    }
  }
  spec {
    replicas = 1
    selector {
      name = "redis"
    }
    template {
      container {
        image = "gcr.io/google_containers/redis:v1"
        name  = "redis"

        port {
          container_port = 6379
        }

        resources {
          limits {
            cpu = "0.1"
          }
        }

        volume_mount {
          name = "data"
          mount_path = "/redis-master-data"
        }
      }

      volume {
        name = "data"
        empty_dir { }
      }
    }
  }
}

resource "kubernetes_replication_controller" "sentinel" {
  metadata {
    name = "redis-sentinel"
    labels {
      name = "redis-sentinel"
      redis-sentinel = "true"
      role = "sentinel"
    }
  }
  spec {
    replicas = 1
    selector {
      redis-sentinel = "true"
    }
    template {
      container {
        image = "gcr.io/google_containers/redis:v1"
        name  = "sentinel"

        env {
          name = "SENTINEL"
          value = "true"
        }
        port {
          container_port = 26379
        }
      }
    }
  }
}
