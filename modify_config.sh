#!/bin/bash
/*
setup:
install jq:
sudo apt-get install jq

manually modify "encryptedPassphrase" and "publicKey" accordling with your configuration

usage:
bash modify_config.sh
*/

configfile='config.json'
cp $configfile "$configfile-original"


DELEGATES='[{"encryptedPassphrase": "salt=*********&cipherText=*************&iv=**********&tag=********&version=1","publicKey": "abf9787621f8f43ec4e4a645b515094f42fc5615f2e231eca24eaf6e69dc6a65"}]'

jq ".forging.delegates = $DELEGATES" "$configfile-original" > config.json
