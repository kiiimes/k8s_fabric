#!/bin/bash

for i  in 0 1 2 3; do
	pid=`docker inspect -f '{{.State.Pid}}' kafka$i`
	pidstat -p $pid 1 -I > ../result/$i.txt &
done 