#!/bin/bash
#Install pushbullet and get an access token. Edit required areas: ACCESS_TOKEN,node,logFile location. Customize watchpatterns to your needs.
#Set script as executable (chmod +x ./notify.sh) and install as a service: (change file name and service name) https://tecadmin.net/run-shell-script-as-systemd-service/
#may need to install bc and jq 'apt-get install jq' and 'apt-get install bc'
urlEX=https://explorer.hydrachain.org/api/address/
urlCG="https://api.coingecko.com/api/"
pushApi="https://api.pushbullet.com/v2/pushes"
usdLOC="v3/simple/price?ids=lockchain&vs_currencies=usd"
usdHYDRA="v3/simple/price?ids=hydra&vs_currencies=usd"
node="HYDRAADDRESS"
watchPattern1="CreateNewBlock"
watchPattern2="Terminating"
watchPattern3="ProcessNetBlock"
logFile=~/.hydra/debug.log
ACCESS_TOKEN=YOURTOKEN
logLine=""

while read -r logLine ; do

        #match Mined Block
    if [[ "$logLine" == *"$watchPattern1"* ]]; then

    #message to console
    #echo "Mined block" $logLine | wall -n
	
	#get info
	responseEX=$(curl -s --request GET "$urlEX$node")
	responseCGH=$(curl -s --request GET "$urlCG$usdHYDRA")
	responseCGL=$(curl -s --request GET "$urlCG$usdLOC")
	usdH=$(echo $responseCGH | jq .hydra.usd | bc)
	usdL=$(echo $responseCGL | jq .lockchain.usd | bc)
	blocks=$(echo $responseEX | jq .blocksMined)
	locs=$(echo $responseEX | jq .blocksMined)
	balanceHR=$(echo $responseEX | jq .balance | bc)
	balanceHYD=$(($balanceHR/100000000))
	balanceLR=$(echo $responseEX | jq .qrc20Balances[2].balance | bc)
	balanceLOC=$(($balanceLR/100000000))
	echo "loc balance:" $balanceHYD
	usdHydra="$(echo "$usdH*$balanceHYD" | bc)"
	usdLoc="$(echo "$usdL*$balanceLOC" | bc)"
	
	    #send info
	echo "Blocks Mined:"$blocks " node:"$node" Hydra Balance:"$balanceHYD "Value:$"$usdHydra "Loc Balance:"$balanceLOC "Loc Value:$"$usdLoc| tee -a "$HOME/notify.log"


	curl -s -u $ACCESS_TOKEN: -X POST $pushApi --header 'Content-Type: application/json' --data-binary '{"type": "note", "title": "'"Block Mined!"'", "body": "'"Blocks Mined:$blocks Node:$node Hydra Balance:$balanceHYD Value:\$$usdHydra Loc Balance:$balanceLOC Loc Value:\$$usdLoc"'"}' >/dev/null 2>&1 
	
	#match error pattern
	elif [[ "$logLine" == *"$watchPattern2"* ]] ; then
      #message to console
      #echo "error" $logLine | wall -n
		echo "error" $logLine | tee -a "$HOME/notify.log"
	curl -s -u $ACCESS_TOKEN: -X POST $pushApi --header 'Content-Type: application/json' --data-binary '{"type": "note", "title": "'"error"'", "body": "'"Check error $logLine"'"}' >/dev/null 2>&1 
	#match new block(status check)
	elif [[ "$logLine" == *"$watchPattern3"* ]] ; then

	
        #message to console
        #echo "Block" $logLine | wall -n
		echo "Block" $logLine | tee -a "$HOME/notify.log"




    fi
done< <(exec tail -fn0 "$logFile")

echo "match = $logLine"
