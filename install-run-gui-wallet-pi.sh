#!/bin/bash
echo -e "stopping any running node. If you are running the QT GUI version please exit manually before updating. If there is a dpkg error it may mean you need to wait for your system to finish updating and then run the script again. "
~/Hydra/bin/./hydra-cli -testnet stop
~/Hydra/bin/./hydra-cli stop
sudo apt -y install unzip build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev libgmp3-dev libzmq3-dev
sudo apt-get -y install software-properties-common
sudo apt-get -y update
sudo apt-get -y install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler qrencode
popd > /dev/null
mkdir ~/Hydra
pushd ~/Hydra
wget -N https://github.com/Hydra-Chain/node/releases/download/hydra_v0.18.5.5/hydra-0.18.5.5-arm-linux-gnueabihf.zip
unzip -o hydra-0.18.5.5-arm-linux-gnueabihf.zip
mkdir ~/.hydra
cp ~/Hydra/hydra.conf ~/.hydra/
popd > /dev/null
pushd ~/Hydra/bin/
echo -e "starting node in daemon mode.."
./hydrad -daemon -rescan -reindex
sleep 15
./hydra-cli -version
sleep 10
./hydra-cli getinfo
echo -e ""
echo -e "Installation complete. HYDRA daemon started in MAINNET. Your wallet is stored by default in ~/.hydra/"
echo -e "You can call the daemon with: \e[0;33m~/Hydra/bin/./hydra-cli getinfo\e[0m"
echo -e "You can stop the daemon with \e[0;33m~/Hydra/bin/./hydra-cli stop\e[0m and use the GUI instead with \e[0;33m~/Hydra/bin/./hydra-qt\e[0m"
echo -e "Find more information at \e[0;33mhttps://hydrachain.org\e[0m"
echo -e ""