#!/bin/bash
docker build -t mousi/multi-client:latest -t mousi/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t mousi/multi-server:latest -t mousi/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t mousi/multi-worker:latest -t mousi/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push mousi/multi-client:latest
docker push mousi/multi-server:latest
docker push mousi/multi-worker:latest

docker push mousi/multi-client:$SHA
docker push mousi/multi-server:$SHA
docker push mousi/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=mousi/multi-server:$SHA
kubectl set image deployments/client-deployment client=mousi/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=mousi/multi-worker:$SHA