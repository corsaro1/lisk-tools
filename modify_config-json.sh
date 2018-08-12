
#!/bin/bash
/*
********************
jq needed. Install it with:
sudo apt-get install jq

#######################################
manually modify "encryptedPassphrase", "publicKey" and external_ip accordling to your configuration
#######################################

********************
*/

configfile='config.json'
cp $configfile "$configfile-original"
external_ip='"2.2.2.2"'


DELEGATES='[{"encryptedPassphrase": "salt=*********&cipherText=*************&iv=**********&tag=********&version=1","publicKey": "abf9787621f8f43ec4e4a645b515094f42fc5615f2e231eca24eaf6e69dc6a65"}]'

jq ".forging.delegates = $DELEGATES" "$configfile-original" > config.json


SSL=' {
      "enabled": true,
      "options": {
        "port": 2443,
        "address": "0.0.0.0",
        "key": "./ssl/lisk.key",
        "cert": "./ssl/lisk.crt"
      }
    }'
cp $configfile "$configfile-temp"
jq ".api.ssl = $SSL" "$configfile-temp" > config.json


API='{
      "public": false,
      "whiteList": [
        "127.0.0.1",'$external_ip'
      ]
    }'
cp $configfile "$configfile-temp"
jq ".api.access = $API" "$configfile-temp" > config.json
    
WHITELIST=' [
        "127.0.0.1",
        '$external_ip'
      ]
'
cp $configfile "$configfile-temp"
jq ".forging.access.whiteList = $WHITELIST" "$configfile-temp" > config.json


