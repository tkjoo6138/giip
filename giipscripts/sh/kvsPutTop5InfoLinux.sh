#!/bin/bash
# Written by Braum 2017019

# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================
factor="Top5Info"
valueJSON=`top -n 1 -b | sed -n '8,12p' | awk '{print "{\"PID\":\""$1"\", \"USER\":\""$2"\", \"%CPU\":\""$9"\", \"%MEM\":\""$10"\", \"TIME\":\""$11"\"}"}'`
valueJSON="{\"$factor\":[ $valueJSON ]}"
echo $valueJSON > JSON
sed -i "s/} {/}, {/g" JSON
valueJSON=`cat JSON`
#echo $valueJSON


# Send Command ==================================================
#<!MEANINGLESS!> rm -f /var/log/lsyncd/lsyncd.log-*

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
wget "http://giip.littleworld.net/API/kvs/put?$qs" -O "giipapi.log"

rm -f giipapi.log
rm -f put?*
