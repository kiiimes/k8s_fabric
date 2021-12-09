#!/bin/bash

for net in $(ifconfig | grep veth | awk -F: '{print $1}'); do
        vnstat -l -i $net -tr 60 > peer_$net.txt &
done
pidstat -G peer 60 1 -I > peer_pidstat.txt & mpstat -P ALL 60 1 > peer_mpstat.txt &
vmstat -t 1 60 > peer_vmstat.txt &
perf sched record -a sleep 60
