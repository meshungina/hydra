#!/bin/bash
echo -e "stopping any running node"
~/Hydra/bin/./hydra-cli -testnet stop
~/Hydra/bin/./hydra-cli stop
sudo apt-get -y autoremove --purge libdb-dev
sudo apt update -y
sudo apt upgrade -y
sudo apt -y install unzip build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev libgmp3-dev libzmq3-dev
sudo apt -y install software-properties-common
mkdir ~/dev
wget -N http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz -P ~/dev/
pushd ~/dev
tar -xvf db-4.8.30.NC.tar.gz
sed -i s/__atomic_compare_exchange/__atomic_compare_exchange_db/g ~/dev/db-4.8.30.NC/dbinc/atomic.h
pushd ~/dev/db-4.8.30.NC/build_unix
mkdir -p build
BDB_PREFIX=/usr/local
../dist/configure --enable-cxx --prefix=$BDB_PREFIX
make
sudo make install
sudo apt-get -y install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler qrencode
popd > /dev/null
mkdir ~/Hydra
pushd ~/Hydra
wget -N https://github.com/Hydra-Chain/node/releases/download/hydra_v0.18.5/hydra-0.18.5-ubuntu20.04-x86_64-gnu.zip
unzip -o hydra-0.18.5-ubuntu20.04-x86_64-gnu.zip
mkdir ~/.hydra
cp ~/Hydra/hydra.conf ~/.hydra/
popd > /dev/null
pushd ~/Hydra/bin/
echo -e "starting node in daemon mode"
./hydrad -daemon -testnet -rescan -reindex
sleep 10
./hydra-cli -version
./hydra-cli -testnet getinfo
echo -e ""
echo -e "Installation complete. HYDRA daemon started in TESTNET. Call the daemon with: \e[0;33m~/Hydra/bin/./hydra-cli -testnet getinfo\e[0m"
echo -e "You can stop the daemon with \e[0;33m~/Hydra/bin/./hydra-cli -testnet stop\e[0m and use the GUI instead with \e[0;33m~/Hydra/bin/./hydra-qt -testnet\e[0m"
echo -e "Find more information at \e[0;33mhttps://hydrachain.org\e[0m"
echo -e ""