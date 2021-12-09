#!/bin/bash

array=()
for container in $(docker ps -q); do
    iflink=`docker exec -it $container bash -c 'cat /sys/class/net/eth0/iflink'`
    iflink=`echo $iflink|tr -d '\r'`
    veth=`grep -l $iflink /sys/class/net/veth*/ifindex`
    veth=`echo $veth|sed -e 's;^.*net/\(.*\)/ifindex$;\1;'`
    array+=($veth)
    echo $container:$veth
done

./measure_cpu_o2.sh &
for i in ${array[@]} 
do 
	./measure_network.sh $i &
done 


sleep 60s
# killall measure_cpu.sh measure_network.sh
killall ifstat pidstat

TIME=`date "+%Y-%m-%d-%I-%M"`
mv ../result ../results/$1_$2_$TIME
mkdir ../result