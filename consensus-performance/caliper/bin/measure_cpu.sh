#!/bin/bash

for i  in 0 1 2; do
	pid=`docker inspect -f '{{.State.Pid}}' orderer$i.oslab.com`
	pidstat -p $pid 1 -I > ../result/$i.txt &
done 