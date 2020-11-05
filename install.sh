#!/bin/bash

# 1. création répertoires
mkdir -p ./assets/etc/prometheus/
mkdir -p ./assets/etc/grafana/
mkdir -p ./assets/data/prometheus
mkdir -p ./assets/data/grafana/
mkdir -p ./assets/bin/

# 2. test node exporter

wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz

tar -xzvf node_exporter-0.18.1.linux-amd64.tar.gz -C ./assets/bin

rm node_exporter-0.18.1.linux-amd64.tar.gz

chmod -R 777 ./assets/

./assets/bin/node_exporter-0.18.1.linux-amd64/node_exporter

# 3. ajout dans grafana

 add source prometheus
 node_memory_MemFree{instance="\$instance",job="node"}
 node_memory_MemTotal


