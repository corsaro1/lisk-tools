## Version 0.9.5.1 original by @mrv
#!/bin/bash

set -e
## Check for config file
CONFIG_FILE="mrv_config_core-1.0.json"

##  Read config file
CONFIGFILE=$(cat "$CONFIG_FILE")
PASSWORD=$( echo "$CONFIGFILE" | jq -r '.password')
LDIRECTORY=$( echo "$CONFIGFILE" | jq -r '.lisk_directory')
SRV1=$( echo "$CONFIGFILE" | jq -r '.srv1')
PRT=$( echo "$CONFIGFILE" | jq -r '.port')
PRTS=$( echo "$CONFIGFILE" | jq -r '.https_port')
PBK=$( echo "$CONFIGFILE" | jq -r '.pbk')
SERVERS=()
### Get servers array
size=$( echo "$CONFIGFILE" | jq '.servers | length') 
i=0

while [ $i -le "$size" ]    
do
	SERVERS[$i]=$(echo "$CONFIGFILE" | jq -r --argjson i $i '.servers[$i]')
	i=$((i + 1))
done
###
#########################

#Set text delay and forging log
TXTDELAY=1
LASTFORGED=""
FORGINGINLOG=0

# Set colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
RESETCOLOR=$(tput sgr0)

## Log start of script
date +"%Y-%m-%d %H:%M:%S || ${GREEN}Starting MrV's consensus script${RESETCOLOR}"


# Set Lisk directory
function ChangeDirectory(){
	cd ~
	eval "cd $LDIRECTORY"
}

while true;
do
	## Get forging status of server
	FORGE=$(curl --connect-timeout 1 --retry 3 --retry-delay 0 --retry-max-time 3 -s "http://"$SRV1""$PRT"/api/node/status/forging?publicKey="$PBK| jq '.data[0].forging')
	if [[ "$FORGE" == "true" ]]; ## Only check log and try to switch forging if needed, if server is currently forging
	then

		if [[ "$FORGINGINLOG" == 0 ]]; ## Log when forging started on node
		then
			date +"%Y-%m-%d %H:%M:%S || ${GREEN}Forging started on node.${RESETCOLOR}"
			FORGINGINLOG=1
		fi
		## Get current server's height and consensus
		SERVERLOCAL=$(curl --connect-timeout 1 --retry 3 --retry-delay 0 --retry-max-time 3 -s "http://"$SRV1""$PRT"/api/node/status")
		HEIGHTLOCAL=$( echo "$SERVERLOCAL" | jq '.data.height')
		CONSENSUSLOCAL=$( echo "$SERVERLOCAL" | jq '.data.consensus')
		## Get recent log
		LOG=$(tail ~/lisk-main/logs/mainnet/lisk.log -n 10)
		
		## Look for a forged block in logs
		FORGEDBLOCKLOG=$( echo "$LOG" | grep 'Forged new block')
		## Display in log if a new block forged and we didn't just display this one
		if [ -n "$FORGEDBLOCKLOG" ] && [ "$LASTFORGED" != "$FORGEDBLOCKLOG" ];
		then
			date +"%Y-%m-%d %H:%M:%S || ${GREEN}$FORGEDBLOCKLOG${RESETCOLOR}"
			LASTFORGED=$FORGEDBLOCKLOG
		fi



		## Check log for Inadequate consensus or Fork & Forged while forging
		INADEQUATE=$( echo "$LOG" | grep 'Inadequate')
		FORGEDBLOCKLOG=$( echo "$LOG" | grep 'Forged new block')
		FORK=$( echo "$LOG" | grep 'Fork')
		if [ -n "$INADEQUATE" ] || ([ -n "$FORK" ] && [ -n "$FORGEDBLOCKLOG" ]);
		then
			if [ -n "$FORK" ] && [ -n "$FORGEDBLOCKLOG" ];
			then
				date +"%Y-%m-%d %H:%M:%S || ${RED}WARNING: Fork and Forged in log.${RESETCOLOR}"
			else
				date +"%Y-%m-%d %H:%M:%S || ${RED}WARNING: Inadequate consensus to forge.${RESETCOLOR}"
			fi
			
			## Disable forging on local server first.  If successful, loop through servers until we are able to enable forging on one
			DISABLEFORGE=$(curl -s -S --connect-timeout 6 -k -H "Content-Type: application/json" -X PUT -d '{"publicKey":"'"$PBK"'", "forging":false, "password":"'"$PASSWORD"'"}' https://"$SRV1""$PRTS"/api/node/status/forging | jq '.data[0].forging')
			if [ "$DISABLEFORGE" = "false" ];
			then
				for SERVER in "${SERVERS[@]}"
				do
					ENABLEFORGE=$(curl -s -S --connect-timeout 6 -k -H "Content-Type: application/json" -X PUT -d '{"publicKey":"'"$PBK"'", "forging":true, "password":"'"$PASSWORD"'"}' https://"$SERVER""$PRTS"/api/node/status/forging | jq '.data[0].forging')
					if [ "$ENABLEFORGE" = "true" ];
					then
						date +"%Y-%m-%d %H:%M:%S || ${CYAN}Successsfully switching to Server $SERVER to try and forge.${RESETCOLOR}"
						break ## Leave servers loop
					else
						date +"%Y-%m-%d %H:%M:%S || ${RED}Failed to enable forging on $SERVER.  Trying next server.${RESETCOLOR}"
					fi
				done
			else
				date +"%Y-%m-%d %H:%M:%S || ${RED}Failed to disable forging on $SRV1.${RESETCOLOR}"
			fi
		fi

	fi
done
