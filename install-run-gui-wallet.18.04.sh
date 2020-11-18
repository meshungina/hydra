#!/bin/bash
sudo apt -y install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev libgmp3-dev libzmq3-dev
sudo apt -y install software-properties-common
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt update -y
sudo apt upgrade -y
sudo apt-get -y install libdb4.8-dev libdb4.8++-dev
sudo apt-get -y install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler qrencode
mkdir ~/Hydra
pushd ~/Hydra
wget https://github.com/LockTrip/Blockchain/releases/download/hydra_testnet_v0.1.0/hydra-0.1.0-ubuntu18.04-x86_64-gnu.zip
unzip hydra-0.1.0-ubuntu18.04-x86_64-gnu.zip
mkdir ~/.hydra
wget https://github.com/LockTrip/Blockchain/releases/download/hydra_testnet_v0.1.0/hydra.conf -P ~/.hydra
popd > /dev/null
pushd ~/Hydra/bin/
./hydra-qt -testnet 