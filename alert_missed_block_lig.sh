#!/bin/sh

#LIG alert group bot

node="https://liskworld.info"

apiToken="xxxx:xxxx"

chat_id="-0000000000"

tel_001="@c***"
tel_002="@s***"
tel_003="@r***"
tel_004="@v***"
tel_005="@o***"
tel_006="@d***"
tel_007="@h***"
tel_008="@l***"

delegate_address_001="3026381832248350807L"
delegate_address_002="13088626869816331666L"
delegate_address_003="15963641443478982497L"
delegate_address_004="9102643396261850794L"
delegate_address_005="765057514163296046L"
delegate_address_006="2324852447570841050L"
delegate_address_007="17670127987160191762L"
delegate_address_008="10310263204519541551L"



s1=$(curl -s "$node/api/delegates?address=$delegate_address_001" | jq .data[0].missedBlocks)
s2=$(curl -s "$node/api/delegates?address=$delegate_address_002" | jq .data[0].missedBlocks)
s3=$(curl -s "$node/api/delegates?address=$delegate_address_003" | jq .data[0].missedBlocks)
s4=$(curl -s "$node/api/delegates?address=$delegate_address_004" | jq .data[0].missedBlocks)
s5=$(curl -s "$node/api/delegates?address=$delegate_address_005" | jq .data[0].missedBlocks)
s6=$(curl -s "$node/api/delegates?address=$delegate_address_006" | jq .data[0].missedBlocks)
s7=$(curl -s "$node/api/delegates?address=$delegate_address_007" | jq .data[0].missedBlocks)
s8=$(curl -s "$node/api/delegates?address=$delegate_address_008" | jq .data[0].missedBlocks)

echo "alert bot avviato"
echo "$s1"
echo "$s2"
echo "$s3"
echo "$s4"
echo "$s5"
echo "$s6"
echo "$s7"
echo "$s8"



curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="Alert bot avviato. Blocchi persi finora: cor $s1; splatters $s2; redsn0w $s3; vekexasia $s4; ondin $s5; dakk $s6; hirish $s7; liskit $s8" -d chat_id=$chat_id

while true; do

    sleep 60

    s1a=$(curl -s "$node/api/delegates?address=$delegate_address_001" | jq .data[0].missedBlocks)
    #s1a="56"
    if [ "$s1" == "$s1a" ]
                then

        sleep 1

    else

                echo "$tel_001 ha perso un blocco. Ora sta a $s1a blocchi persi"
                curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="$tel_001 ha perso un blocco. Ora sta a $s1a blocchi persi" -d chat_id=$chat_id
                sleep 10
                s1=$(curl -s "$node/api/delegates?address=$delegate_address_001" | jq .data[0].missedBlocks)
                echo $s1
    fi


    s2a=$(curl -s "$node/api/delegates?address=$delegate_address_002" | jq .data[0].missedBlocks)
    if [ "$s2" == "$s2a" ]
                then

        sleep 1

    else

                echo "$tel_002 ha perso un blocco. Ora sta a $s2a blocchi persi"
                curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="$tel_002 ha perso un blocco. Ora sta a $s2a blocchi persi" -d chat_id=$chat_id
                sleep 1
                s2=$(curl -s "$node/api/delegates?address=$delegate_address_002" | jq .data[0].missedBlocks)
                echo $s2
    fi



    s3a=$(curl -s "$node/api/delegates?address=$delegate_address_003" | jq .data[0].missedBlocks)
    if [ "$s3" == "$s3a" ]
                then

        sleep 1

    else

                echo "$tel_003 ha perso un blocco. Ora sta a $s3a blocchi persi"
                curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="$tel_003 ha perso un blocco. Ora sta a $s3a blocchi persi" -d chat_id=$chat_id
                sleep 1
                s3=$(curl -s "$node/api/delegates?address=$delegate_address_003" | jq .data[0].missedBlocks)
                echo $s3
    fi



    s4a=$(curl -s "$node/api/delegates?address=$delegate_address_004" | jq .data[0].missedBlocks)
    if [ "$s4" == "$s4a" ]
                then

        sleep 1

    else

                echo "$tel_004 ha perso un blocco. Ora sta a $s4a blocchi persi"
                curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="$tel_004 ha perso un blocco. Ora sta a $s4a blocchi persi" -d chat_id=$chat_id
                sleep 1
                s4=$(curl -s "$node/api/delegates?address=$delegate_address_004" | jq .data[0].missedBlocks)
                echo $s4
    fi


    s5a=$(curl -s "$node/api/delegates?address=$delegate_address_005" | jq .data[0].missedBlocks)
    if [ "$s5" == "$s5a" ]
                then

        sleep 1

    else

                echo "$tel_005 ha perso un blocco. Ora sta a $s5a blocchi persi"
                curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="$tel_005 ha perso un blocco. Ora sta a $s5a blocchi persi" -d chat_id=$chat_id
                sleep 1
                s5=$(curl -s "$node/api/delegates?address=$delegate_address_005" | jq .data[0].missedBlocks)
                echo $s5
    fi


    s6a=$(curl -s "$node/api/delegates?address=$delegate_address_006" | jq .data[0].missedBlocks)
    if [ "$s6" == "$s6a" ]
                then

        sleep 1

    else

                echo "$tel_006 ha perso un blocco. Ora sta a $s5a blocchi persi"
                curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="$tel_006 ha perso un blocco. Ora sta a $s6a blocchi persi" -d chat_id=$chat_id
                sleep 1
                s6=$(curl -s "$node/api/delegates?address=$delegate_address_006" | jq .data[0].missedBlocks)
                echo $s6
    fi


    s7a=$(curl -s "$node/api/delegates?address=$delegate_address_007" | jq .data[0].missedBlocks)
    if [ "$s7" == "$s7a" ]
                then

        sleep 1

    else

                echo "$tel_007 ha perso un blocco. Ora sta a $s7a blocchi persi"
                curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="$tel_007 ha perso un blocco. Ora sta a $s7a blocchi persi" -d chat_id=$chat_id
                sleep 1
                s7=$(curl -s "$node/api/delegates?address=$delegate_address_007" | jq .data[0].missedBlocks)
                echo $s7
    fi



    s8a=$(curl -s "$node/api/delegates?address=$delegate_address_008" | jq .data[0].missedBlocks)
    if [ "$s8" == "$s8a" ]
                then

        sleep 1

    else

                echo "$tel_008 ha perso un blocco. Ora sta a $s8a blocchi persi"
                curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="$tel_008 ha perso un blocco. Ora sta a $s8a blocchi persi" -d chat_id=$chat_id
                sleep 1
                s8=$(curl -s "$node/api/delegates?address=$delegate_address_008" | jq .data[0].missedBlocks)
                echo $s8
    fi



done
