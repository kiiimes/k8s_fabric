#!/bin/bash

sshpass -p 1 ssh -t -t oslab@163.152.20.138 "cd eskim/fabric_script && echo '1' | sudo -S ./measure_orderer.sh && mkdir orderer1 && mv *.txt orderer1 && mv perf.data orderer1" > a.txt&
