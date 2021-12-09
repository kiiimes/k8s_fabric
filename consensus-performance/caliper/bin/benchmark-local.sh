#!/bin/bash

CONSENSUS_NAME=$1

npx caliper benchmark run --caliper-workspace ../  \
--caliper-benchconfig benchmarks/scenario/smallbank/config.yaml \
--caliper-networkconfig network/caliper/$CONSENSUS_NAME/fabric-go-local.yaml

TIME=`date "+%Y-%m-%d-%I-%M"`
mv ../report.html ../results/$1_$2_$TIME.html
rm -rf /tmp/$CONSENSUS_NAME*
