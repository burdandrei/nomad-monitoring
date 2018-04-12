job "telegraf" {
  datacenters = ["dc1"]
  type        = "system"

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  update {
    stagger      = "1s"
    max_parallel = 100
  }

  group "telegraf" {
    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "telegraf" {
      driver = "docker"
      config {
        network_mode = "host"
        image        = "telegraf:alpine"
        force_pull   = true
        args = [
          "-config",
          "/local/telegraf.conf",
        ]
      }

      template {
        data = <<EOTC
# Adding Client class
# This should be here until https://github.com/hashicorp/nomad/pull/3882 is merged
{{ $node_class := env "node.class" }}
[global_tags]
{{ if $node_class }}
  nomad_client_class = "{{ env "node.class" }}"
{{else}}
  nomad_client_class = "none"
{{ end }}

[agent]
  interval = "10s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "3s"
  precision = ""
  debug = false
  quiet = false
  hostname = ""
  omit_hostname = false
[[outputs.influxdb]]
  urls = ["http://influxdb.service.consul:8086"]
  database = "telegraf"
  retention_policy = "autogen"
  timeout = "5s"
  user_agent = "telegraf-{{env "NOMAD_TASK_NAME" }}"
[[inputs.prometheus]]
urls = ["http://{{ env "attr.unique.network.ip-address" }}:4646/v1/metrics?format=prometheus"]
EOTC
        destination = "local/telegraf.conf"
      }

      resources {
        cpu    = 100
        memory = 128

        network {
          mbits = 10
        }
      }
    }
  }
}
