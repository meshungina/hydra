#!/bin/bash
echo deb http://security.ubuntu.com/ubuntu lucid-security main restricted universe multiverse | sudo sh -c 'cat >>/etc/apt/sources.list'
sudo apt update
sudo apt upgrade
sudo apt-get install libdb4.8++
sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler qrencode
sudo apt install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev libgmp3-dev libzmq3-dev
sudo apt install software-properties-common
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev libgmp3-dev
sudo apt-get install software-properties-common
sudo apt-get update
sudo apt upgrade
sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler qrencode
mkdir ~/Hydra
pushd ~/Hydra
wget https://github.com/LockTrip/Blockchain/releases/download/hydra_testnet_v0.1.0/hydra-0.1.0-ubuntu20.04-x86_64-gnu.zip
unzip hydra-0.1.0-ubuntu20.04-x86_64-gnu.zip
mkdir ~/.hydra
wget https://github.com/LockTrip/Blockchain/releases/download/hydra_testnet_v0.1.0/hydra.conf -P ~/.hydra
popd > /dev/null
pushd ~/Hydra/bin/
./hydra-qt -testnet -minimumchainwork="00000000000000000000000000000000000000000000000000000000138b138b"