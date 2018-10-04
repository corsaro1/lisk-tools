#!/bin/sh
#LIG alert group bot
node="https://liskworld.info"
apiToken="000000:AAAAAA"
chat_id="-000000000" #test

delegate_array=( 3026381832248350807L 13088626869816331666L 15963641443478982497L 9102643396261850794L 765057514163296046L 2324852447570841050L 17670127987160191762L 10310263204519541551L )
s_array=( s1 s2 s3 s4 s5 s6 s7 s8 )
sa_array=( s1a s2a 23a s4a s5a s6a s7a s8a )
tel_array=( @c**** @s**** @r**** @e**** @o*** @d**** @h*** @g**** )
n=0
nx=0
contatore=0
for i in "${delegate_array[@]}"
        do
        echo $n
        echo ${s_array[$n]}
        s_array[$n]=$(curl -s "$node/api/delegates?address=$i" | jq .data[0].missedBlocks)
        echo ${s_array[$n]}
        n=$(expr $n + 1)
        if [ "$n" == "8" ]
                then
        n="0"
        fi
        done
echo "alert bot avviato"
curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="Alert bot avviato. Blocchi persi finora: corsaro ${s_array[0]}; splatters ${s_array[1]}; redsn0w ${s_array[2]}; vekexasia ${s_array[4]}; dakk ${s_array[5]}; hirish ${s_array[6]}; liskit ${s_array[7]}" -d chat_id=$chat_id

while true; do
         sleep 60
        for i in "${delegate_array[@]}"
                do
        echo $nx
        sa_array[$nx]=$(curl -s "$node/api/delegates?address=$i" | jq .data[0].missedBlocks)
        echo ${sa_array[$nx]}
        if [ "${s_array[$nx]}" != "${sa_array[$nx]}" ]
                then
                echo "${tel_array[$nx]} ha perso un blocco. Ora sta a ${sa_array[$nx]} blocchi persi"
                curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="${tel_array[$nx]} ha perso un blocco. Ora sta a ${sa_array[$nx]} blocchi persi" -d chat_id=$chat_id
                sleep 10
                s_array[$nx]=$(curl -s "$node/api/delegates?address=$i" | jq .data[0].missedBlocks)
                echo ${s_array[$nx]}
              fi
nx=$(expr $nx + 1)

if [ "$nx" == "8" ]
  then
nx="0"
fi
done
currenttime=$(date +%H:%M)
contatore=$(expr $contatore + 1)
if [ "$contatore" == "3600" ]
  then
curl -s -X POST https://api.telegram.org/bot$apiToken/sendMessage -d text="bot is live. Time is $currenttime" -d chat_id=$chat_id
contatore="0"
fi

done
