#!/bin/bash

# List of drives to check
drives="sdc sdd sde sdf"

# File to store metrics temporarily
metrics_file="/var/lib/drive_temp_metrics.prom"

# Clear the file
> "$metrics_file"

# Loop through each drive and run smartctl
for drive in $drives; do
    temp=$(smartctl -a "/dev/$drive" | grep "Current" | awk '{print $4}')
    # Write Prometheus metric format
    echo "drive_temperature_celsius{drive=\"/dev/$drive\"} $temp" >> "$metrics_file"
done

