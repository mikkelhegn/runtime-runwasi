#!/usr/bin/env bash

# Create cluster
k3d cluster create runwasi-runtime --image ghcr.io/deislabs/containerd-wasm-shims/examples/k3d:v0.9.2 -p "8081:80@loadbalancer" --agents 1

# Install shim
agent_node_id=$(docker ps --format json | jq -r '. as $objects | $objects | select(.Names == "k3d-runwasi-runtime-agent-0") | .ID')
server_node_id=$(docker ps --format json | jq -r '. as $objects | $objects | select(.Names == "k3d-runwasi-runtime-server-0") | .ID')
docker cp k3d/containerd-shim-spin-v1 $agent_node_id:/bin/containerd-shim-spin-v1
docker cp k3d/containerd-shim-spin-v1 $server_node_id:/bin/containerd-shim-spin-v1

# build app and container
pushd redis-runtime
nmp install
spin build
docker buildx build --platform wasi/wasm --provenance=false -t spin-runtime .
k3d image import -c runwasi-runtime spin-runtime

# Deploy Application
kubectl apply -f spin-runtime.yaml
kubectl apply -f redis.yaml
kubectl delete -f spin-app.yaml
kubectl apply -f spin-app.yaml

# Test connection
# sleep 15
kubectl port-forward svc/wasm-spin 3000:80
