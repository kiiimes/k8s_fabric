#!/bin/bash
rm -rf channel-artifacts crypto-config
mkdir channel-artifacts

cryptogen generate --config=./crypto-config.yaml

export FABRIC_CFG_PATH=$PWD
echo $FABRIC_CFG_PATH

configtxgen -profile OrdererGenesis -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block

sleep 1s

configtxgen -profile ChannelConfig -channelID oslab -outputCreateChannelTx ./channel-artifacts/channel.tx

sleep 1s

configtxgen -profile ChannelConfig -channelID oslab -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -asOrg Org1MSP

sleep 1s

configtxgen -profile ChannelConfig -channelID oslab -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -asOrg Org2MSP

export CLIENT_1_KEY=$(ls ./crypto-config/peerOrganizations/org1.oslab.com/users/User1@org1.oslab.com/msp/keystore/) 
mv ./crypto-config/peerOrganizations/org1.oslab.com/users/User1@org1.oslab.com/msp/keystore/${CLIENT_1_KEY}  ./crypto-config/peerOrganizations/org1.oslab.com/users/User1@org1.oslab.com/msp/keystore/client1_key
export CLIENT_2_KEY=$(ls ./crypto-config/peerOrganizations/org2.oslab.com/users/User1@org2.oslab.com/msp/keystore/) 
mv ./crypto-config/peerOrganizations/org2.oslab.com/users/User1@org2.oslab.com/msp/keystore/${CLIENT_2_KEY}  ./crypto-config/peerOrganizations/org2.oslab.com/users/User1@org2.oslab.com/msp/keystore/client2_key

export ORG_1_KEY=$(ls ./crypto-config/peerOrganizations/org1.oslab.com/users/Admin@org1.oslab.com/msp/keystore/)
mv ./crypto-config/peerOrganizations/org1.oslab.com/users/Admin@org1.oslab.com/msp/keystore/${ORG_1_KEY} ./crypto-config/peerOrganizations/org1.oslab.com/users/Admin@org1.oslab.com/msp/keystore/org1_key
export ORG_2_KEY=$(ls ./crypto-config/peerOrganizations/org2.oslab.com/users/Admin@org2.oslab.com/msp/keystore/)
mv ./crypto-config/peerOrganizations/org2.oslab.com/users/Admin@org2.oslab.com/msp/keystore/${ORG_2_KEY} ./crypto-config/peerOrganizations/org2.oslab.com/users/Admin@org2.oslab.com/msp/keystore/org2_key

export CA_1_KEY=$(ls ./crypto-config/peerOrganizations/org1.oslab.com/ca/*_sk)
mv ${CA_1_KEY} ./crypto-config/peerOrganizations/org1.oslab.com/ca/ca1_key
export CA_2_KEY=$(ls ./crypto-config/peerOrganizations/org2.oslab.com/ca/*_sk)
mv ${CA_2_KEY} ./crypto-config/peerOrganizations/org2.oslab.com/ca/ca2_key

export CA_1_TLS_KEY=$(ls ./crypto-config/peerOrganizations/org1.oslab.com/tlsca/*_sk)
mv ${CA_1_TLS_KEY} ./crypto-config/peerOrganizations/org1.oslab.com/tlsca/ca1_tls_key
export CA_2_TLS_KEY=$(ls ./crypto-config/peerOrganizations/org2.oslab.com/tlsca/*_sk)
mv ${CA_2_TLS_KEY} ./crypto-config/peerOrganizations/org2.oslab.com/tlsca/ca2_tls_key
