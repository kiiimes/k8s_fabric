#!/bin/bash

## additional orderer
IPADDRESS=172.57.0
HOST_IPADDRESS=10.0.0.22
NET_INTERFACE=$1

sudo route add -net $IPADDRESS.0 netmask 255.255.0.0 gw $HOST_IPADDRESS
echo "DONE"
sudo iptables -A FORWARD -i $NET_INTERFACE -j ACCEPT
echo "DONE"
sudo iptables -P FORWARD ACCEPT
echo "DONE"

# Orderer 
IPADDRESS=172.51.0
HOST_IPADDRESS=10.0.0.201
HOST_IPADDRESS=10.0.0.12
NET_INTERFACE=$1

sudo route add -net $IPADDRESS.0 netmask 255.255.0.0 gw $HOST_IPADDRESS
echo "DONE"
sudo iptables -A FORWARD -i $NET_INTERFACE -j ACCEPT
echo "DONE"
sudo iptables -P FORWARD ACCEPT
echo "DONE"

## Kafka 1
IPADDRESS=172.52.0
HOST_IPADDRESS=10.0.0.22
NET_INTERFACE=$1

sudo route add -net $IPADDRESS.0 netmask 255.255.0.0 gw $HOST_IPADDRESS
echo "DONE"
sudo iptables -A FORWARD -i $NET_INTERFACE -j ACCEPT
echo "DONE"
sudo iptables -P FORWARD ACCEPT
echo "DONE"

## Kafka 2
IPADDRESS=172.59.0
HOST_IPADDRESS=10.0.0.200
NET_INTERFACE=$1

sudo route add -net $IPADDRESS.0 netmask 255.255.0.0 gw $HOST_IPADDRESS
echo "DONE"
sudo iptables -A FORWARD -i $NET_INTERFACE -j ACCEPT
echo "DONE"
sudo iptables -P FORWARD ACCEPT
echo "DONE"

# CA
IPADDRESS=172.54.0
HOST_IPADDRESS=10.0.0.202
NET_INTERFACE=$1

sudo route add -net $IPADDRESS.0 netmask 255.255.0.0 gw $HOST_IPADDRESS
echo "DONE"
sudo iptables -A FORWARD -i $NET_INTERFACE -j ACCEPT
echo "DONE"
sudo iptables -P FORWARD ACCEPT
echo "DONE"

# Zookeeper
IPADDRESS=172.55.0
HOST_IPADDRESS=10.0.0.202
NET_INTERFACE=$1

sudo route add -net $IPADDRESS.0 netmask 255.255.0.0 gw $HOST_IPADDRESS
echo "DONE"
sudo iptables -A FORWARD -i $NET_INTERFACE -j ACCEPT
echo "DONE"
sudo iptables -P FORWARD ACCEPT
echo "DONE"

# additional orderer
IPADDRESS=172.56.0
HOST_IPADDRESS=10.0.0.200
NET_INTERFACE=$1

sudo route add -net $IPADDRESS.0 netmask 255.255.0.0 gw $HOST_IPADDRESS
echo "DONE"
sudo iptables -A FORWARD -i $NET_INTERFACE -j ACCEPT
echo "DONE"
sudo iptables -P FORWARD ACCEPT
echo "DONE"
route -n

# Peer 
IPADDRESS=172.53.0
HOST_IPADDRESS=10.0.0.25
NET_INTERFACE=$1

sudo route add -net $IPADDRESS.0 netmask 255.255.0.0 gw $HOST_IPADDRESS
echo "DONE"
sudo iptables -A FORWARD -i $NET_INTERFACE -j ACCEPT
echo "DONE"
sudo iptables -P FORWARD ACCEPT
echo "DONE"
route -n

