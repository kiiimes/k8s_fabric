#!/bin/bash

NODE_NAME=$2
CONSENSUS_NAME=$1
CPUS=2
DOCKER_PATH="../network/docker-compose/num_nodes"
SCRIPT_PATH=''

if [ $CONSENSUS_NAME == "r" ]; then
	SCRIPT_PATH=$DOCKER_PATH/raft/
fi
if [ $CONSENSUS_NAME == "p" ]; then
	SCRIPT_PATH=$DOCKER_PATH/pbft/
fi
if [ $CONSENSUS_NAME == "k" ]; then
	SCRIPT_PATH=$DOCKER_PATH/kafka/
fi

docker-compose -f $SCRIPT_PATH$NODE_NAME.yaml up -d 

if [ $NODE_NAME == "p" ]; then
	for i in 1 2; do
		for j in 0 1; do
			docker update --cpus $CPUS peer$j.org$i.oslab.com 
		done
	done 
fi 

if [ $NODE_NAME == "c" ]; then
	for i in 1 2; do
		docker update --cpus $CPUS ca.org$i.oslab.com
	done 
fi 

if [ $NODE_NAME == "o2" ]; then
	for i in 3 4; do
		docker update --cpus $CPUS orderer$i.oslab.com
	done 
fi 

if [ $NODE_NAME == "o" ] && [ $CONSENSUS_NAME != "p" ]; then
	for i in 0 1 2; do
		docker update --cpus $CPUS orderer$i.oslab.com
	done 
elif [ $NODE_NAME == "o" ] && [ $CONSENSUS_NAME == "p" ]; then
	for i in 0 1 2 3; do
		docker update --cpus $CPUS orderer$i.oslab.com
	done
fi 

if [ $NODE_NAME == "kafka" ]; then
	for i in 0 1 2 3; do
		docker update --cpus $CPUS kafka$i
	done 
fi 

if [ $NODE_NAME == "zookeeper" ]; then
	for i in 0 1 2; do
		docker update --cpus $CPUS zookeeper$i
	done 
fi 
