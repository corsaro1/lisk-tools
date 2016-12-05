#!/bin/bash
SECRET="\"YOUR SECRET HERE\""
SRV1="xxx.xxx.xxx.xxx"
SRV2="xxx.xxx.xxx.xxx"

PRT1=":8000"
PRT2=":8000"

pbk="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"


HEIGHT1=$(curl --connect-timeout 3 -s "http://"$SRV1""$PRT1"/api/loader/status/sync"| jq '.height')
HEIGHT2=$(curl --connect-timeout 3 -s "http://"$SRV2""$PRT2"/api/loader/status/sync"| jq '.height')


FORGE1=$(curl --connect-timeout 3 -s "http://"$SRV1""$PRT1"/api/delegates/forging/status?publicKey="$pbk| jq '.enabled')
FORGE2=$(curl --connect-timeout 3 -s "http://"$SRV2""$PRT2"/api/delegates/forging/status?publicKey="$pbk| jq '.enabled')





echo ""
echo $SRV1 " " $HEIGHT1 " " $FORGE1
echo $SRV2 " " $HEIGHT2 " " $FORGE2
echo ""



if ! [[ "$HEIGHT1" =~ ^[0-9]+$ ]]
        then
            echo $SRV1 " " "is off?"
            HEIGHT1="0"
fi

if ! [[ "$HEIGHT2" =~ ^[0-9]+$ ]]
        then
            echo $SRV3 " " "is off?"
            HEIGHT2="0"
fi

if [ "$HEIGHT1" -eq "$HEIGHT2" ]
   then
   
   
     echo tutto a posto
     exit
	
fi










if [ "$FORGE1" = "false" -a "$FORGE2" = "false" ]
   then
     if [ "$HEIGHT1" -gt "0" ]
     then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":2443/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":2443/api/delegates/forging/disable
    
    echo ""
    echo "condizione di emergenza 1a"
     
     elif [ "$HEIGHT2" -gt "0" ]
     then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":2443/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":2443/api/delegates/forging/enable
    
      echo ""
    echo "condizione di emergenza 1b"
   
     
     

     else
         echo ""
    echo "condizione di emergenza totale"

     
     fi
fi







if [ "$FORGE1" = "true" -a "$FORGE2" = "true" ]
   then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":2443/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":2443/api/delegates/forging/disable
 

    echo ""
    echo "condizione di emergenza 2"
fi











if [ "$HEIGHT1" -gt "$HEIGHT2" ]
   then
       diff=$(( $HEIGHT1 - $HEIGHT2 ))
     if [ "$diff" -gt "3" ]
    then
    curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":2443/api/delegates/forging/enable
    curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":2443/api/delegates/forging/disable
     
     
     echo "$SRV1"  "  "  
    echo   is greather
     fi
	
fi


if [ "$HEIGHT2" -gt "$HEIGHT1" ]
   then
    diff=$(( $HEIGHT2 - $HEIGHT1 ))
    if [ "$diff" -gt "3" ]
    then
   curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":2443/api/delegates/forging/disable
   curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":2443/api/delegates/forging/enable
   
   
     echo "$SRV2"  "  "  
    echo   is greater
   fi  
	
fi


