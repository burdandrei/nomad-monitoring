job "influxdb" {
  datacenters = ["dc1"]

  type = "service"
  
  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    auto_revert = false
    canary = 0
  }

  group "influxdb" {
    count = 1

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    ephemeral_disk {
      migrate = true
      size    = "1024"
      sticky  = true
    }

    task "influxdb" {
      driver = "docker"

      config {
        image = "influxdb:alpine"
        port_map {
          http = 8086
        }
      }

      resources {
        cpu    = 500
        memory = 500
        network {
          mbits = 10
          port "http" {
            static = "8086"
          }
        }
      }

      service {
        name = "influxdb"
        port = "http"
        check {
          name     = "InfluxDB HTTP"
          type     = "http"
          path     = "/ping"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}