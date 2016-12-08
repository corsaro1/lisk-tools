#!/bin/bash
SECRET="\"YOUR SECRET HERE\""
SRV1="xxx.xxx.xxx.xxx"
SRV2="xxx.xxx.xxx.xxx"
SRV3="xxx.xxx.xxx.xxx"
SRV4="xxx.xxx.xxx.xxx"

PORT="8000"
SSLPORT="2443"

pbk1="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

while true; do
HEIGHT1=$(curl --connect-timeout 6 -s "http://"$SRV1":"$PORT"/api/loader/status/sync"| jq '.height')
HEIGHT2=$(curl --connect-timeout 6 -s "http://"$SRV2":"$PORT"/api/loader/status/sync"| jq '.height')
HEIGHT3=$(curl --connect-timeout 6 -s "http://"$SRV3":"$PORT"/api/loader/status/sync"| jq '.height')
HEIGHT4=$(curl --connect-timeout 6 -s "http://"$SRV4":"$PORT"/api/loader/status/sync"| jq '.height')


FORGE1=$(curl --connect-timeout 6 -s "http://"$SRV1":"$PORT"/api/delegates/forging/status?publicKey="$pbk1| jq '.enabled')
FORGE2=$(curl --connect-timeout 6 -s "http://"$SRV2":"$PORT"/api/delegates/forging/status?publicKey="$pbk1| jq '.enabled')
FORGE3=$(curl --connect-timeout 6 -s "http://"$SRV3":"$PORT"/api/delegates/forging/status?publicKey="$pbk1| jq '.enabled')
FORGE4=$(curl --connect-timeout 6 -s "http://"$SRV4":"$PORT"/api/delegates/forging/status?publicKey="$pbk1| jq '.enabled')

echo ""
echo $SRV1 " " $HEIGHT1 " " $FORGE1
echo $SRV2 " " $HEIGHT2 " " $FORGE2
echo $SRV3 " " $HEIGHT3 " " $FORGE3
echo $SRV4 " " $HEIGHT4 " " $FORGE4
echo ""



if ! [[ "$HEIGHT1" =~ ^[0-9]+$ ]]
        then
        HEIGHT1=$(curl --connect-timeout 6 -s "http://"$SRV1":"$PORT"/api/loader/status/sync"| jq '.height')
       if ! [[ "$HEIGHT1" =~ ^[0-9]+$ ]]
        then
            echo ""
            echo $SRV1 " " "is off?"
            HEIGHT1="0"
            FORGE1="false"
       fi
fi



if ! [[ "$HEIGHT2" =~ ^[0-9]+$ ]]
        then
        HEIGHT2=$(curl --connect-timeout 6 -s "http://"$SRV2":"$PORT"/api/loader/status/sync"| jq '.height')
     if ! [[ "$HEIGHT2" =~ ^[0-9]+$ ]]
        then
            echo ""
            echo $SRV2 " " "is off?"
            HEIGHT2="0"
            FORGE2="false"
     fi
fi



if ! [[ "$HEIGHT3" =~ ^[0-9]+$ ]]
        then
        HEIGHT3=$(curl --connect-timeout 3 -s "http://"$SRV3":"$PORT"/api/loader/status/sync"| jq '.height')
        if ! [[ "$HEIGHT3" =~ ^[0-9]+$ ]]
        then
            echo ""
            echo $SRV3 " " "is off?"
            HEIGHT3="0"
            FORGE3="false"
            fi
fi


if ! [[ "$HEIGHT4" =~ ^[0-9]+$ ]]
        then
        HEIGHT4=$(curl --connect-timeout 3 -s "http://"$SRV4":"$PORT"/api/loader/status/sync"| jq '.height')
        if ! [[ "$HEIGHT4" =~ ^[0-9]+$ ]]
        then
            echo ""
            echo $SRV4 " " "is off?"
            HEIGHT4="0"
            FORGE4="false"
            fi
fi





if [ "$FORGE1" = "false" -a "$FORGE2" = "false" -a "$FORGE3" = "false" -a "$FORGE4" = "false" ]
   then
     if [ "$HEIGHT1" -gt "0" ]
     then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

    echo ""
    echo "condizione di emergenza 1a"
     
     elif [ "$HEIGHT2" -gt "0" ]
     then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

      echo ""
    echo "condizione di emergenza 1b"
   
     
     
     elif [ "$HEIGHT3" -gt "0" ]
     then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

         echo ""
    echo "condizione di emergenza 1c"




     elif [ "$HEIGHT4" -gt "0" ]
     then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/enable

         echo ""
    echo "condizione di emergenza 1d"








     else
         echo ""
    echo "condizione di emergenza totale"

     
     fi
fi




if [ "$FORGE1" = "true" -a "$FORGE2" = "true" -o "$FORGE1" = "true" -a "$FORGE3" = "true" -o "$FORGE2" = "true" -a "$FORGE3" = "true" -o "$FORGE1" = "true" -a "$FORGE4" = "true" -o 

"$FORGE2" = "true" -a "$FORGE4" = "true" -o "$FORGE3" = "true" -a "$FORGE4" = "true" ]
   then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

    echo ""
    echo "condizione di emergenza 2"
fi







if [ "$HEIGHT1" -eq "$HEIGHT2" -a "$HEIGHT1" -eq "$HEIGHT3" -a "$HEIGHT1" -eq "$HEIGHT4" -a "$HEIGHT2" -eq "$HEIGHT3" -a "$HEIGHT2" -eq "$HEIGHT4" -a "$HEIGHT3" -eq "$HEIGHT4" ]
   then
     echo tutto a posto
 #    exit
	
fi


if [ "$HEIGHT1" -eq "$HEIGHT2" -a "$HEIGHT1" -gt "$HEIGHT3" -a "$HEIGHT1" -gt "$HEIGHT4" ]
   then
          diff=$(( $HEIGHT1 - $HEIGHT3 ))
     if [ "$diff" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV1"  "  "  
    echo   is greather caso 1
   fi  
	
fi





if [ "$HEIGHT1" -eq "$HEIGHT3" -a "$HEIGHT1" -gt "$HEIGHT2" -a "$HEIGHT1" -gt "$HEIGHT4" ]
   then
          diff=$(( $HEIGHT1 - $HEIGHT2 ))
     if [ "$diff" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV1"  "  "  
    echo   is greather caso 2
   fi  
	
fi


if [ "$HEIGHT1" -eq "$HEIGHT4" -a "$HEIGHT1" -gt "$HEIGHT2" -a "$HEIGHT1" -gt "$HEIGHT3" ]
   then
          diff=$(( $HEIGHT1 - $HEIGHT2 ))
     if [ "$diff" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV1"  "  "  
    echo   is greather caso 2
   fi  
	
fi





if [ "$HEIGHT2" -eq "$HEIGHT4" -a "$HEIGHT2" -gt "$HEIGHT1" -a "$HEIGHT2" -gt "$HEIGHT3" ]
   then
          diff=$(( $HEIGHT2 - $HEIGHT3 ))
     if [ "$diff" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV2"  "  "  
    echo   is greather caso 2
   fi  
	
fi





if [ "$HEIGHT3" -eq "$HEIGHT4" -a "$HEIGHT3" -gt "$HEIGHT1" -a "$HEIGHT3" -gt "$HEIGHT2" ]
   then
          diff=$(( $HEIGHT2 - $HEIGHT3 ))
     if [ "$diff" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV3"  "  "  
    echo   is greather caso 2
   fi  
	
fi




if [ "$HEIGHT2" -eq "$HEIGHT3" -a "$HEIGHT2" -gt "$HEIGHT1" -a "$HEIGHT2" -gt "$HEIGHT4" ]
   then
          diff=$(( $HEIGHT2 - $HEIGHT1 ))
     if [ "$diff" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV2"  "  "  
    echo   is greather caso 3
   fi  
	
fi






if [ "$HEIGHT1" -eq "$HEIGHT2" -a "$HEIGHT1" -eq "$HEIGHT3" -a "$HEIGHT1" -gt "$HEIGHT4" ]
   then
          diff=$(( $HEIGHT2 - $HEIGHT1 ))
     if [ "$diff" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV1"  "  "  
    echo   is greather caso 3
   fi  
	
fi




if [ "$HEIGHT1" -eq "$HEIGHT2" -a "$HEIGHT1" -eq "$HEIGHT4" -a "$HEIGHT1" -gt "$HEIGHT3" ]
   then
          diff=$(( $HEIGHT1 - $HEIGHT3 ))
     if [ "$diff" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV1"  "  "  
    echo   is greather caso 3
   fi  
	
fi




if [ "$HEIGHT2" -eq "$HEIGHT3" -a "$HEIGHT2" -eq "$HEIGHT4" -a "$HEIGHT2" -gt "$HEIGHT1" ]
   then
          diff=$(( $HEIGHT2 - $HEIGHT1 ))
     if [ "$diff" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV2"  "  "  
    echo   is greather caso 3
   fi  
	
fi










if [ "$HEIGHT1" -gt "$HEIGHT2" -a "$HEIGHT1" -gt "$HEIGHT3" -a "$HEIGHT1" -gt "$HEIGHT4" ]
   then
          diff=$(( $HEIGHT1 - $HEIGHT2 ))
          diff2=$(( $HEIGHT1 - $HEIGHT3 ))
     if [ "$diff" -gt "3" -a "$diff2" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV1"  "  "  
    echo   is greather caso 4
   fi  
	
fi




if [ "$HEIGHT2" -gt "$HEIGHT1" -a "$HEIGHT2" -gt "$HEIGHT3" -a "$HEIGHT2" -gt "$HEIGHT4" ]
   then
          diff=$(( $HEIGHT2 - $HEIGHT3 ))
          diff2=$(( $HEIGHT2 - $HEIGHT1 ))
     if [ "$diff" -gt "3" -a "$diff2" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV2"  "  "  
    echo   is greather caso 5
   fi  
	
fi





if [ "$HEIGHT3" -gt "$HEIGHT1" -a "$HEIGHT3" -gt "$HEIGHT2" -a "$HEIGHT3" -gt "$HEIGHT4" ]
   then
          diff=$(( $HEIGHT3 - $HEIGHT1 ))
          diff2=$(( $HEIGHT3 - $HEIGHT2 ))
     if [ "$diff" -gt "3" -a "$diff2" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/enable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/disable

     echo "$SRV3"  "  "  
    echo   is greather caso 6
   fi  
	
fi

if [ "$HEIGHT4" -gt "$HEIGHT1" -a "$HEIGHT4" -gt "$HEIGHT2" -a "$HEIGHT4" -gt "$HEIGHT3" ]
   then
          diff=$(( $HEIGHT3 - $HEIGHT1 ))
          diff2=$(( $HEIGHT3 - $HEIGHT2 ))
     if [ "$diff" -gt "3" -a "$diff2" -gt "3" ]
    then
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV3":"$SSLPORT"/api/delegates/forging/disable
    curl --connect-timeout 6 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV4":"$SSLPORT"/api/delegates/forging/enable

     echo "$SRV4"  "  "  
    echo   is greather caso 6
   fi  
	
fi


   sleep 30
   done
