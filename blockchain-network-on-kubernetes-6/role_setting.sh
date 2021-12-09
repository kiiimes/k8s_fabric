#!/bin/bash

#각 서버의 pod 역할 지정
kubectl label nodes oslab fabricType=orderer
kubectl label nodes oslab2 fabricType=ca
kubectl label nodes server3 fabricType=peer
kubectl label nodes baas2 fabricType=others

kubectl get nodes --show-labels
