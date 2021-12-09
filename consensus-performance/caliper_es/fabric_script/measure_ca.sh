#!/bin/bash

for net in $(ifconfig | grep veth | awk -F: '{print $1}'); do
        vnstat -l -i $net -tr 60 > ca_$net.txt &
done
pidstat -G fabric-ca 60 1 -I > ca_pidstat.txt & mpstat -P ALL 60 1 > ca_mpstat.txt &
perf sched record -a sleep 60
