##  original script from corsaro. Modified by liberspirita
####################################################
## modifications are :
## SRV1 is prefered anyway when the 2 nodes are OK
## unactivate forging on SRV2 if both are activated
## activate forging on SRV1 if none is activated
## secret write only once in variable
####################################################
##
## auto select forging script, version for 2 nodes
## Requirements are: 1 fixed IP (home IP, office IP, VPN or VPS are fine) and 2 cheap VPS
## https needed
## jq is needed. instal it with:
## sudo apt-get install jq
## you have to whitelist on config.json (on the API and FORGING section), the IP of the machine where the script is running
## Inside the script you have to write your SECRET seed
## on this version, I use https on port 2443
##
#!/bin/bash
SECRET="\"YOUR SECRET HERE\""
SRV1="1.2.3.4" # ip or host if set in /etc/hosts
SRV2="5.6.7.8"  # ip or host if set in /etc/hosts
PRT1=":7000"   # 7000 on testnet, 8000 on mainnet
PRT2=$PRT1     # same port used on both server
PRTS=":2443"   # port used on https
pbk="YOUR PUBLIC KEY HERE"
while true; do
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
            echo $SRV2 " " "is off?"
            HEIGHT2="0"
fi
## deactiver une forge si toutes le sont
if [ "$HEIGHT1" -eq "$HEIGHT2" ] && [ "$FORGE1" == "$FORGE2" ] && [ "$FORGE1" == "true" ]  
   then
    curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2""$PRTS"/api/delegates/forging/disable
    fi
## activer une forge si aucune ne l'est
if [ "$HEIGHT1" -eq "$HEIGHT2" ] && [ "$FORGE1" == "$FORGE2" ] && [ "$FORGE1" == "false" ]  
   then
    curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1""$PRTS"/api/delegates/forging/enable
    fi
## activer la forge principale si elle est acceptable
if [ "$HEIGHT1" -eq "$HEIGHT2" ] && [ "$FORGE2" == "true" ] && [ "$FORGE1" == "false" ]  
   then
    curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1""$PRTS"/api/delegates/forging/enable
    curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2""$PRTS"/api/delegates/forging/disable
    fi
if [ "$HEIGHT1" -eq "$HEIGHT2" ]
   then
   
   
     echo everything is fine
#     exit
    
fi
if [ "$HEIGHT1" -gt "$HEIGHT2" ] && [ "$FORGE1" != "true" ] && [ "$FORGE2" != "true" ]
   then
       diff=$(( $HEIGHT1 - $HEIGHT2 ))
     if [ "$diff" -gt "3" ]
    then
    curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1""$PRTS"/api/delegates/forging/enable
    curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2""$PRTS"/api/delegates/forging/disable
     echo
     echo "$SRV1 is greater"
     fi
    
fi
if [ "$HEIGHT2" -gt "$HEIGHT1" ] && [ "$FORGE2" != "true" ] && [ "$FORGE1" != "true" ]
   then
    diff=$(( $HEIGHT2 - $HEIGHT1 ))
    if [ "$diff" -gt "3" ]
    then
   curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV1""$PRTS"/api/delegates/forging/disable
   curl --connect-timeout 3 -k -H "Content-Type: application/json" -X POST -d '{"secret":'"$SECRET"'}' https://"$SRV2""$PRTS"/api/delegates/forging/enable
     echo
     echo "$SRV2 is greater"
   fi  
    
fi
   sleep 60
   done
