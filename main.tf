variable "context" {}
variable "ip" {}
variable "image" {}
variable "storage" {}
variable "memory" {}

variable "port" {
  default = 9200
}

variable "stack" {
  default = "elasticsearch"
}

resource "kubernetes_service" "main" {
  wait_for_load_balancer = "false"
  metadata {
    name = "${var.stack}-${var.context}"
  }
  spec {
    selector = {
      app = "${var.stack}-${var.context}"
    }
    port {
      port        = var.port
      target_port = var.port
    }
    type         = "LoadBalancer"
    external_ips = ["${var.ip}"]
  }
}

resource "kubernetes_deployment" "main" {
  metadata {
    name = "${var.stack}-${var.context}"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "${var.stack}-${var.context}"
      }
    }
    template {
      metadata {
        labels = {
          app = "${var.stack}-${var.context}"
        }
      }
      spec {
        container {
          image = var.image
          name  = "${var.stack}-${var.context}"
          volume_mount {
            name       = "${var.stack}-${var.context}"
            mount_path = "/usr/share/elasticsearch/data"
          }
        }
        env {
          name  = "ES_JAVA_OPTS"
          value = "-Xms${var.memory}g -Xmx${var.memory}g"
        }
        volume {
          name = "${var.stack}-${var.context}"
          persistent_volume_claim {
            claim_name = "${var.stack}-${var.context}"
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "main" {
  metadata {
    name = "${var.stack}-${var.context}"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage
      }
    }
    storage_class_name = "rook-ceph-block"
  }
}
