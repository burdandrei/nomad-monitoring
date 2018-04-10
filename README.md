# Monitoring Nomad with InfluxDB

This tutorial walks you through setting up Nomad monitoring pipeline using Prometheus publisher, Telegraf prometheus input, Kafka as message queue, InfluxDB as time series database and Grafana for visualisation.

# Metrics Flow

`Nomad` -> `Telegraf Harvester` -> `Kafka` -> `Telegraf Consumer` -> `InfluxDB`

# Configs

- Nomad
- Telegraf
- Grafana dashboards
