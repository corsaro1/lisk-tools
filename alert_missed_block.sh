## sudo apt install jq
## sudo apt install mailutils
    ###then choose: internet site



#!/bin/sh

delegate_address="3026381832248350807L"
your_email="email@domain.tld"
telegram_contact="xx_yy"

s1=$(curl -s "https://node01.lisk.io/api/delegates?address=$delegate_address" | jq .data[0].missedBlocks)
echo $s1

/snap/bin/telegram-cli -W -e "msg $telegram_contact alert check for missed blocks started. $s1 missed until now"

while true; do

	sleep 60
    s2=$(curl -s "https://node01.lisk.io/api/delegates?address=$delegate_address" | jq .data[0].missedBlocks)
    

    if [ "$s1" == "$s2" ]
		then
          
        sleep 10
	
    else
     
		echo "alert you missed a block"
		mail -s "block missed" $your_email < /dev/null
		/snap/bin/telegram-cli -W -e "msg $telegram_contact you missed a new block. You are at $s2 missed now"
		sleep 10
		s1=$(curl -s "https://node01.lisk.io/api/delegates?address=$delegate_address" | jq .data[0].missedBlocks)
		echo $s1


	fi

done


