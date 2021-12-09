#!/bin/bash

cd /home/oslab/go/src/github.com/eskim/blockchain-network-on-kubernetes-6 && ./setup_blockchainNetwork3.sh
cd /home/oslab/go/src/github.com/consensus-performance/caliper_es/bin/ && ./benchmark.sh raft test > b.txt &

check=`ps -ef | grep -v "grep" | grep "ClientWorker" | wc -l`
while [ ${check} -eq 0 ]
do
	check=`ps -ef | grep -v "grep" | grep "ClientWorker" | wc -l`
done

sshpass -p 1 ssh -t -t oslab@163.152.20.138 "cd eskim/fabric_script && echo '1' | sudo -S ./measure_orderer.sh && mkdir orderer1 && mv *.txt orderer1 && mv perf.data orderer1" > a.txt&
sshpass -p 1 ssh -t -t oslab2@163.152.20.139 "cd eskim/fabric_script && echo '1' | sudo -S ./measure_ca.sh && mkdir ca1 && mv *.txt ca1 && mv perf.data ca1" > c.txt&
sshpass -p 1 ssh -t -t server3@163.152.20.140 "cd eskim/fabric_script && echo '1' | sudo -S ./measure_peer.sh && mkdir peer1 && mv *.txt peer1 && mv perf.data peer1" > d.txt

sshpass -p 1 ssh -t -t oslab@163.152.20.138 "cd go/src/github.com/consensus-performance/caliper/bin && ./stop.sh raft" > a.txt&
sshpass -p 1 ssh -t -t oslab2@163.152.20.139 "cd go/src/github.com/consensus-performance/caliper/bin && ./stop.sh raft" > a.txt&
sshpass -p 1 ssh -t -t server3@163.152.20.140 "cd go/src/github.com/consensus-performance/caliper/bin && ./stop.sh raft" > a.txt

cd /home/oslab/go/src/github.com/eskim/blockchain-network-on-kubernetes-6 && ./deleteNetwork.sh
cd /home/oslab/go/src/github.com/consensus-performance/caliper_es/fabric_script
