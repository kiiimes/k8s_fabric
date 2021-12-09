#!/bin/bash

cd /home/oslab/go/src/github.com/eskim/blockchain-network-on-kubernetes-6 && ./setup_blockchainNetwork.sh
cd /home/oslab/go/src/github.com/consensus-performance/caliper_es/bin/ && ./benchmark.sh raft test > b.txt &

check=`ps -ef | grep -v "grep" | grep "ClientWorker" | wc -l`
while [ ${check} -eq 0 ]
do
	check=`ps -ef | grep -v "grep" | grep "ClientWorker" | wc -l`
done

StartTime=$(date +%s)

wait

EndTime=$(date +%s)
echo "It takes $(($EndTime - $StartTime)) seconds to complete this task."

sshpass -p 1 ssh -t -t oslab@163.152.20.138 "cd go/src/github.com/consensus-performance/caliper/bin && ./stop.sh raft" > a.txt&
sshpass -p 1 ssh -t -t oslab2@163.152.20.139 "cd go/src/github.com/consensus-performance/caliper/bin && ./stop.sh raft" > a.txt&
sshpass -p 1 ssh -t -t server3@163.152.20.140 "cd go/src/github.com/consensus-performance/caliper/bin && ./stop.sh raft" > a.txt

cd /home/oslab/go/src/github.com/eskim/blockchain-network-on-kubernetes-6 && ./deleteNetwork.sh
cd /home/oslab/go/src/github.com/consensus-performance/caliper_es/fabric_script
