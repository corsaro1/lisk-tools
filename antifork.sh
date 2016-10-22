#!/bin/bash

#modified from original script on https://forum.lisk.io/viewtopic.php?t=395 by sgdias

tail -Fn0 ./logs/lisk.log |
while read line ; do

    echo "$line" | grep "Fork"
    if [ $? = 0 ]; then
        echo "Fork found: $line"
    fi

    
       echo "$line" | grep "\"cause\":2"
    if [ $? = 0 ]; then
        echo "Fork with root cause code 2 found. Restarting node main."
        echo "Auto restarting node..."
        bash lisk.sh stop
        sleep 5
        bash lisk.sh start
        echo "Auto Restarting Done"

    fi


     echo "$line" | grep "\"cause\":3"
    if [ $? = 0 ]; then
        echo "Fork with root cause code 3 found. Restarting node lisk."
        echo "Auto rebuilding node..."
        bash lisk.sh rebuild

        echo "Auto Rebuilding Done"

    fi


done