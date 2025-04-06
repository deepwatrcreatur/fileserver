#!/bin/bash

# List of drives to check
drives="sdc sdd sde sdf"

# File to store metrics temporarily
metrics_file="/tmp/drive_temp_metrics.prom"

# Clear the file
> "$metrics_file"

# Loop through each drive and run smartctl
for drive in $drives; do
    temp=$(smartctl -a "/dev/$drive" | grep "Current" | awk '{print $4}')
    # Write Prometheus metric format
    echo "drive_temperature_celsius{drive=\"/dev/$drive\"} $temp" >> "$metrics_file"
done

# Push metrics to Grafana Cloud
GRAFANA_CLOUD_URL="https://deepwatrcreatur.grafana.net" # Replace with your URL
GRAFANA_CLOUD_USER="deepwatrcreatur"  # Replace with your Grafana Cloud Prometheus user ID
GRAFANA_CLOUD_API_KEY="insert key here"  # Replace with your Grafana Cloud API key

curl -u "$GRAFANA_CLOUD_USER:$GRAFANA_CLOUD_API_KEY" \
     --data-binary "@$metrics_file" \
     "$GRAFANA_CLOUD_URL"
