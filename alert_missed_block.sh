## sudo apt install jq
## sudo apt install mailutils
    ###then choose: internet site

#sudo apt-get install snapd
#sudo snap install telegram-cli
	###then configure telegram-cli
	
	
### first time launch:
### /snap/bin/telegram-cli 

### phone number:    #better to use a dedicated phone number for this ubuntu account)

### once telegram-cli is configured prompt is shown
### >

### then add your "smartphone" telegram account, where you want to receive alerts, with:

### add_contact +xxxxxxxxx xx yy

### then exit from prompt with ctrl+c

### and test if everything works

### /snap/bin/telegram-cli -W -e "msg xx_yy hi how are you"

### > contact_list to see all contacts



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


