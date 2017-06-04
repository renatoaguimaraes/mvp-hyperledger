!#/bin/sh

docker stop $(docker ps -a -q)

docker rm $(docker ps -a -q)

rm -rf crypto-config

./bin/cryptogen generate --config=./crypto-config.yaml

export FABRIC_CFG_PATH=$PWD

./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID bancos

./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/SicoobMSPanchors.tx -channelID bancos -asOrg SicoobMSP

./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/BancoBrasilPanchors.tx -channelID bancos -asOrg BancoBrasilMSP

 CHANNEL_NAME=bancos TIMEOUT=60 docker-compose -f docker-compose-cli.bancos.yaml up 