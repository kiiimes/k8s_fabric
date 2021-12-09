#!/bin/bash

sudo mount -t nfs 10.0.0.23:/mnt/s2 /mnt/eskim
sshpass -p 1 ssh -t -p 22 oslab@163.152.20.139 "su - root && mount -t nfs 10.0.0.23:/mnt/s2 /mnt/eskim/tmp"

#sshpass -p 1 server3@

