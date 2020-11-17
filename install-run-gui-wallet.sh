#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt-get --yes --force-yes install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler qrencode
sudo apt --yes install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev libgmp3-dev libzmq3-dev
sudo apt --yes install software-properties-common
mkdir ~/dev
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz -P ~/dev/
pushd ~/dev
tar -xvf db-4.8.30.NC.tar.gz
sed -i s/__atomic_compare_exchange/__atomic_compare_exchange_db/g ~/dev/db-4.8.30.NC/dbinc/atomic.h
pushd ~/dev/db-4.8.30.NC/build_unix
mkdir -p build
BDB_PREFIX=/usr/local
../dist/configure --enable-cxx --prefix=$BDB_PREFIX
make
sudo make install
sudo apt-get --yes install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev libgmp3-dev
sudo apt-get --yes install software-properties-common
sudo apt-get update -y
sudo apt upgrade -y
sudo apt-get --yes install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler qrencode
popd > /dev/null
mkdir ~/Hydra
pushd ~/Hydra
wget https://github.com/LockTrip/Blockchain/releases/download/hydra_testnet_v0.1.0/hydra-0.1.0-ubuntu20.04-x86_64-gnu.zip
unzip hydra-0.1.0-ubuntu20.04-x86_64-gnu.zip
mkdir ~/.hydra
wget https://github.com/LockTrip/Blockchain/releases/download/hydra_testnet_v0.1.0/hydra.conf -P ~/.hydra
popd > /dev/null
pushd ~/Hydra/bin/
./hydra-qt -testnet -minimumchainwork="00000000000000000000000000000000000000000000000000000000138b138b"