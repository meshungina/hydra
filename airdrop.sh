#!/bin/bash
#Fetches LOC/HYDRA balances of confirmed users for airdrop at chosen block from api exports results to xlsx file
#required: sed,grep,jq,bc,unoconv
#run as: ./airdrop.sh userlist blocknumber
timestamp=""
filename="$1"
height=$"$2"
balanceHYD=""
balanceLOC=""
expurlH="https://explorer.hydrachain.org/balance/hydra?address="
expurlL="https://explorer.hydrachain.org/balance/loc?address="
responseH=""
responseL=""
balanceHYD=""
balanceLOC=""
balanceHR=""
balanceLR=""
con="Confirmed"
rej="Rejected"
add="Additional"
status="Yes"
words=""
startTime="$(date +%s)"
endTime=""
empty="Empty"
totalTime="unset"
count=0

sed -r 's/^\s*//; s/\s*$//; /^$/d' "$filename" | grep "^[hHtTR]" > "$height.txt"
sleep 2
filename="$height.txt"



	while read -r -a words || [ -n "$words" ]; do
	
if [ -z "${words[0]}" ];
	then
	echo "LINE EMPTY"
	break

else
if [ -z "${words[1]}" ];
	then
	echo "STATUS EMPTY"
	words[1]=$empty
fi

	

if [  "${words[1]}" = $con ];
	then
	status="Yes"
	responseH=$(curl -sS --max-time 2 "https://explorer.hydrachain.org/balance/hydra?address=${words[0]}&height=$height")
	#echo "responseH $responseH"
	#sleep 0.5
    responseL=$(curl -sS --max-time 2 "https://explorer.hydrachain.org/balance/loc?address=${words[0]}&height=$height")
	#echo "responseL $responseL"
	balanceHR=$(echo $responseH | jq .balance | bc)

		if [ -z "$balanceHR" ]
	then
		echo "\$balanceHR is NULL"
		balanceHR=0
	#else
		#echo "\$balanceHR is OK"
		fi
	#echo "balanceHR $balanceHR"
	balanceHYD=$(jq -n $balanceHR/100000000)
	#echo "balanceHYD $balanceHYD"
	balanceLR=$(echo $responseL | jq .tokens[0].balance | bc)
		if [ -z "$balanceLR" ]
	then
		echo "\$balanceLR is NULL"
		balanceLR=0
	#else
		#echo "\$balanceLR is OK"
		fi
	#echo "balanceLR $balanceLR"
	balanceLOC=$(jq -n $balanceLR/100000000)
	#echo "balanceLOC $balanceLOC"
else
	echo "unconfirmed ${words[1]}"
	status="No"
	balanceHYD=0
	balanceLOC=0	
fi
fi


echo -e "${words[0]}","$balanceHYD","$balanceLOC","$height","${words[1]}","$status" | tee -a "$height.csv"
#sleep 0.5


m=$((m++))
echo "Lines Processed:$((++CNT))"
endTime="$(date +%s)"
done < "$filename"
totalTime=$(( $endTime - $startTime ))
#echo "start:$startTime end:$endTime"
format() {
    local sec tot r

    sec="$1"

    r="$((sec%60))s"
    tot=$((sec%60))

    if [[ "$sec" -gt "$tot" ]]; then
        r="$((sec%3600/60))m:$r"
        let tot+=$((sec%3600))
    fi

    if [[ "$sec" -gt "$tot" ]]; then
        r="$((sec%86400/3600))h:$r"
        let tot+=$((sec%86400))
    fi

    if [[ "$sec" -gt "$tot" ]]; then
        r="$((sec/86400))d:$r"
    fi

    echo -e "Test complete\nTotal time: $r"
}
unoconv -f xls $height.csv
echo "saved "$height".xls"
format totalTime
