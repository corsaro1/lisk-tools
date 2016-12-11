#!/bin/bash
SRV1="liskworld.info"
PRT="8000"
MYADDRESS="3026381832248350807L"
MYUSERNAME="\"corsaro"\"


pbk1="ac09bc40c889f688f9158cca1fcfcdf6320f501242e0f7088d52a5077084ccba"


my_array=$(curl --connect-timeout 6 -s "http://"$SRV1":8000/api/delegates/getNextForgers?limit=101" | jq '.delegates')


block=`curl -s "http://"$SRV1":"$PRT"/api/accounts/delegates?q=username&address="$MYADDRESS"" | jq '.delegates[]  | select(.username == '$MYUSERNAME') | .producedblocks'`
block2=`curl -s "http://"$SRV1":"$PRT"/api/accounts/delegates?q=username&address="$MYADDRESS"" | jq '.delegates[]  | select(.username == '$MYUSERNAME') | .missedblocks'`



echo
echo
echo "turni mancanti " " "
echo ${my_array[@]/$pbk1//} | cut -d/ -f1 | wc -w | tr -d ' '
echo ""
echo ""
echo blocchi prodotti
echo $block
echo
echo blocchi persi
echo $block2
