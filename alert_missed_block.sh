## sudo apt install jq
## sudo apt install mailutils
    ###then choose: internet site



#!/bin/sh

delegate_address="3026381832248350807L"
your_email="email@domain.tld"

missedblocks=$(curl -s "https://node01.lisk.io/api/delegates?address=$delegate_address" | jq .data[0].missedBlocks)
echo $missedblocks

while true; do

    s1=$(curl -s "https://node01.lisk.io/api/delegates?address=$delegate_address" | jq .data[0].missedBlocks)
    sleep 60
    s2=$(curl -s "https://node01.lisk.io/api/delegates?address=$delegate_address" | jq .data[0].missedBlocks)
    

    if [ "$s1" == "$s2" ]
   then
          
        sleep 10
	
    else
     
      echo "you missed a block"
      mail -s "block missed" $your_email < /dev/null
	sleep 10
fi

done

