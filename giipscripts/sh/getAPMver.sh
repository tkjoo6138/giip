#!/bin/bash
# Written by Lowy Shin at 20160627
# 사전 작업
rpm -qa | egrep "php-[1-9]|httpd-[1-9]|mariadb-[0-9]" | awk -F- '{print $1$2}' | sort -n > verInfo.txt
cat verInfo.txt | tr "\n" "\t" > verInfo 
awk '{print $1,$2,$3}' verInfo

# System Variables ===============================================
sk="c08e03ebee199e6623283e695580f97f"
lssn="70813"

# User Variables ===============================================
factor="APM ver"
valueJSON=`awk '{print "{\"Appache\":\""$1"\",\"MairaDB\":\""$2"\",\"PHP\":\""$3"\"}"}' verInfo`
valueJSON="{\"$factor\":[ $valueJSON ]}" 

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
wget "http://giip.littleworld.net/API/kvs/put?$qs" -O "giipapi.log"

rm -f giipapi.log
rm -f put?*
