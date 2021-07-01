#!/bin/bash
#Install pushbullet and get an access token. Edit required areas: ACCESS_TOKEN,node,logFile location. Customize watchpatterns as needed.
#Set script as executable (chmod +x ./notify.sh) and install as a service: (change file name and service name)
#Here's a good guide: https://tecadmin.net/run-shell-script-as-systemd-service/
#may need to install bc and jq -> 'apt-get install jq' and 'apt-get install bc' execute script with './notify.sh'

urlEX=https://explorer.hydrachain.org/api/address/
urlCG="https://api.coingecko.com/api/"
pushApi="https://api.pushbullet.com/v2/pushes"
usdLOC="v3/simple/price?ids=lockchain&vs_currencies=usd"
usdHYD="v3/simple/price?ids=hydra&vs_currencies=usd"
node="WALLETADDRESS"
watchPattern1="  update"
watchPattern2="CreateNewBlock"
watchPattern3="Shutdown"
watchPattern4="ProcessNetBlock"
logFile=~/.hydra/debug.log
ACCESS_TOKEN=PUSHBULLETTOKEN
logLine=""
responseEX=""
responseCGH=""
responseCGL=""
usdH=""
usdL=""
blocks=""
balanceHR=""
balanceHYD=""
balanceLR=""
balanceLOC=""
usdHYDRA=""
usdLoc=""

fetchAllData () {
	responseEX=$(curl -s --request GET "$urlEX$node")
	responseCGH=$(curl -s --request GET "$urlCG$usdHYD")
	responseCGL=$(curl -s --request GET "$urlCG$usdLOC")
	usdH=$(echo $responseCGH | jq .hydra.usd | bc)
	usdL=$(echo $responseCGL | jq .lockchain.usd | bc)
	blocks=$(echo $responseEX | jq .blocksMined)
	balanceHR=$(echo $responseEX | jq .balance | bc)
	balanceHYD=$(($balanceHR/100000000))
	balanceLR=$(echo $responseEX | jq -r '.qrc20Balances[] | select(.symbol == "LOC") | {balance}' | grep -Po "\\d+" | bc)
	balanceLOC=$(($balanceLR/100000000))
	usdHYDRA="$(echo "$usdH*$balanceHYD" | bc)"
	usdLoc="$(echo "$usdL*$balanceLOC" | bc)"
}


while read -r logLine ; do

	#match addtowallet by "  update" pattern
	if [[ "$logLine" == *"$watchPattern1"* ]] ; then
      #message to console
        #echo "addtowallet" $logLine
		echo "addtowallet "$node" " $logLine | wall -n
		echo "addtowallet "$node" " $logLine | tee -a "$HOME/notify.log"
	#sleeping so explorer can catch up and we can grab correctly updated values
	sleep 30
	    #get info from fetchAllData function

    fetchAllData
	
	    #send info to log
	echo "addtowallet:"$node"-"$blocks"-Hydra Balance:"$balanceHYD-"Value:$"$usdHYDRA "LocBalance:"$balanceLOC "LocValue:$"$usdLoc| tee -a "$HOME/notify.log"

		#send to pushbullet
	curl -s -u $ACCESS_TOKEN: -X POST $pushApi --header 'Content-Type: application/json' --data-binary '{"type": "note", "title": "'"HYDRA BALANCE CHANGED"'", "body": "'"NODE:$node - BLOCKS:$blocks - New balance:$balanceHYD - Value:\$$usdHYDRA - Loc Balance:$balanceLOC - Loc Value:\$$usdLoc - Log: $logLine "'"}' >/dev/null 2>&1 
	

        #match Mined Block
    elif [[ "$logLine" == *"$watchPattern2"* ]]; then
		
		#message to console
     
	echo "Mined block" $logLine | wall -n
	#sleeping so explorer can catch up and we can grab correctly updated values
	sleep 30
	    #get info from fetchAllData function

    fetchAllData
	
	    #send info to log
	echo "Blocks Mined for:"$node" :"$blocks" Hydra Balance:"$balanceHYD "Value:$"$usdHYDRA "Loc Balance:"$balanceLOC "Loc Value:$"$usdLoc| tee -a "$HOME/notify.log"

		#send to pushbullet
	curl -s -u $ACCESS_TOKEN: -X POST $pushApi --header 'Content-Type: application/json' --data-binary '{"type": "note", "title": "'"NEW BLOCK MINED!"'", "body": "'"Total Mined for $node: $blocks - Hydra Balance:$balanceHYD - Value:\$$usdHYDRA - Loc Balance:$balanceLOC - Loc Value:\$$usdLoc - Log: $logLine "'"}' >/dev/null 2>&1 
	
	#match Shutdown pattern
	elif [[ "$logLine" == *"$watchPattern3"* ]] ; then
      #message to console
        #echo "Shutdown" $logLine
		echo "Shutdown" $logLine | wall -n
		echo "Shutdown" $logLine | tee -a "$HOME/notify.log"
	curl -s -u $ACCESS_TOKEN: -X POST $pushApi --header 'Content-Type: application/json' --data-binary '{"type": "note", "title": "'"Shutdown"'", "body": "'"Check Shutdown $logLine"'"}' >/dev/null 2>&1 
	
	#match new block(status check)
	
	elif [[ "$logLine" == *"$watchPattern4"* ]] ; then

	    #message to console
        #echo "Block" $logLine | wall -n
		echo "Block" $logLine | tee -a "$HOME/notify.log"

    fi
done< <(exec tail -fn0 "$logFile")

echo "match = $logLine"
