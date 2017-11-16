#!/bin/bash
# Written by Lowy Shin at 20160627

# System Variables ===============================================
sk="{{sk}}"
lssn="{{lssn}}"

# User Variables ===============================================

factor="AIXUsage"

CU=`sar 1 5 | grep "Average" | awk '{print $2}'`

MU=`svmon -G |grep memory |perl -ane 'printf"%0.1f\n", 100 - ( ( $F[3] / $F[1] ) * 100 )'`

DU=`df -k | head -2 | tail -1 | awk '{print $4}' |sed 's/\%//g'`

valueJSON=`echo {\"CPUUsage\":\"$CU\",\"MemoryUsage\":\"$MU\",\"DiskUsage\":\"$DU\"}`
valueJSON="{\"$factor\":[ $valueJSON ]}"
echo $valueJSON


# Send Command ==================================================
#<!MEANINGLESS!> rm -f /var/log/lsyncd/lsyncd.log-*

# Send to KVSAPI Server =========================================
qs="sk=$sk&type=lssn&key=$lssn&factor=$factor&value=$valueJSON"
wget -O "giipapi.log" "http://giip.littleworld.net/API/kvs/put?$qs"

rm -f giipapi.log
rm -f put?*
