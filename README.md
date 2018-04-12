# Monitoring Nomad with InfluxDB

This tutorial walks you through setting up Nomad monitoring pipeline using Prometheus publisher, Telegraf prometheus input, Kafka as message queue, InfluxDB as time series database and Grafana for visualisation.

# Metrics Flow

`Nomad` -> `Telegraf` -> `InfluxDB`

# Configs

- Nomad
  * Telemetry should be enabled with Prometheus metrics:
  ```hcl
  telemetry {
    publish_allocation_metrics = true
    publish_node_metrics       = true
    prometheus_metrics         = true
  }
  ```
- Telegraf
  * Prometheus input:
  ```TOML
  [[inputs.prometheus]]
  urls = ["http://{{NOMAD_NODE_ADDRESS}}:4646/v1/metrics?format=prometheus"]
  ```
- Grafana dashboards
  * [Grafana.com Dashbords](https://grafana.com/dashboards?dataSource=influxdb&collector=Telegraf&search=nomad)
  * [Example Nomad jobs with pre-configured data sources and dashboards](https://github.com/burdandrei/nomad-monitoring/tree/master/examples/jobs/grafana.nomad)
