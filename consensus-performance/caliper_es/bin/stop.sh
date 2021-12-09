#!/bin/bash
CONSENSUS_NAME=$1
docker kill $(docker ps -aq)
docker rm $(docker ps -aq)

docker network rm ${CONSENSUS_NAME}_ca
docker network rm ${CONSENSUS_NAME}_peer
docker network rm ${CONSENSUS_NAME}_orderer

if [ $CONSENSUS_NAME == 'kafka' ]; then
	docker network rm ${CONSENSUS_NAME}_kafka
fi 