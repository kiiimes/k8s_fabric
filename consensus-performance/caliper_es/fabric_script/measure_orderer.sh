#!/bin/bash

for net in $(ifconfig | grep veth | awk -F: '{print $1}'); do
        vnstat -l -i $net -tr 60 > orderer_$net.txt &
done
pidstat -G orderer 60 1 -I > orderer_pidstat.txt & mpstat -P ALL 60 1 > orderer_mpstat.txt &
vmstat -t 1 60 > orderer_vmstat.txt &
perf sched record -a sleep 60
