#!/bin/bash

for i  in 3 4; do
	pid=`docker inspect -f '{{.State.Pid}}' orderer$i.oslab.com`
	pidstat -p $pid 1 -I > ../result/$i.txt &
done 