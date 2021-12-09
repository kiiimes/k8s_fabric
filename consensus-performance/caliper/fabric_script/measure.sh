#!/bin/bash

#cd /home/oslab/go/src/github.com/eskim/blockchain-network-on-kubernetes-6 && ./setup_blockchainNetwork.sh
#cd /home/oslab/go/src/github.com/consensus-performance/caliper_es/bin/ && ./benchmark.sh raft test > b.txt &

sshpass -p 1 ssh -t -t oslab@163.152.20.138 "cd go/src/github.com/consensus-performance/caliper/bin && echo '1' | sudo -S ./start.sh r o" > e.txt
sshpass -p 1 ssh -t -t oslab2@163.152.20.139 "cd go/src/github.com/consensus-performance/caliper/bin && echo '1' | sudo -S ./start.sh r c" > f.txt
sshpass -p 1 ssh -t -t server3@163.152.20.140 "cd go/src/github.com/consensus-performance/caliper/bin && echo '1' | sudo -S ./start.sh r p" > g.txt

cd /home/oslab/go/src/github.com/consensus-performance/caliper/bin/ && ./benchmark.sh raft test > b.txt &

check=`ps -ef | grep -v "grep" | grep "ClientWorker" | wc -l`
while [ ${check} -eq 0 ]
do
	check=`ps -ef | grep -v "grep" | grep "ClientWorker" | wc -l`
done

StartTime=$(date +%s)

sshpass -p 1 ssh -t -t oslab@163.152.20.138 "cd eskim/fabric_script && echo '1' | sudo -S ./measure_orderer.sh && mkdir orderer3 && mv *.txt orderer3 && mv perf.data orderer3" > a.txt&
sshpass -p 1 ssh -t -t oslab2@163.152.20.139 "cd eskim/fabric_script && echo '1' | sudo -S ./measure_ca.sh && mkdir ca3 && mv *.txt ca3 && mv perf.data ca3" > c.txt&
sshpass -p 1 ssh -t -t server3@163.152.20.140 "cd eskim/fabric_script && echo '1' | sudo -S ./measure_peer.sh && mkdir peer3 && mv *.txt peer3 && mv perf.data peer3" > d.txt

sshpass -p 1 ssh -t -t oslab@163.152.20.138 "cd go/src/github.com/consensus-performance/caliper/bin && ./stop.sh raft" > k.txt
sshpass -p 1 ssh -t -t oslab2@163.152.20.139 "cd go/src/github.com/consensus-performance/caliper/bin && ./stop.sh raft" > j.txt
sshpass -p 1 ssh -t -t server3@163.152.20.140 "cd go/src/github.com/consensus-performance/caliper/bin && ./stop.sh raft" > w.txt

EndTime=$(date +%s)
echo "It takes $(($EndTime - $StartTime)) seconds to complete this task."

#cd /home/oslab/go/src/github.com/eskim/blockchain-network-on-kubernetes-6 && ./deleteNetwork.sh
cd /home/oslab/go/src/github.com/consensus-performance/caliper/fabric_script
