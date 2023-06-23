#!/bin/bash

# wait fo k8s ready
while ! kubectl get nodes | grep -w "Ready"; do
  echo "WAIT FOR NODES READY"
  sleep 1
done
touch /ks/.k8sfinished

# mark init finished
touch /ks/.initfinished

curl -LO https://github.com/redpanda-data/redpanda/releases/latest/download/rpk-linux-amd64.zip
mkdir -p ~/.local/bin
unzip rpk-linux-amd64.zip -d ~/.local/bin/
export PATH="~/.local/bin:$PATH"






  