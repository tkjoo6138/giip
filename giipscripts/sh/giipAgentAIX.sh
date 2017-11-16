#!/bin/bash
# giipAgent Ver. 1.2
# Written by Lowy Shin at 20140922
# 170705 Lowy, Fix execute shell not haver 755 permission.
# {{today}} : Replace today to "YYYYMMDD"
# User Variables ===============================================
sk=""
lssn=""

# Check os2unix
CHECK_Converter=`which dos2unix`
RESULT=`echo $?`

#OS Check
ostype=`uname -a`
if [ $ostype = "Ubuntu" ];then
        os=`lsb_release -d`
        os=`echo "$os"| sed -e "s/Description\://g"`

        if [ ${RESULT} != 0 ];then
                apt-get install -y dos2unix
        fi
else
        os=`uname -a`

        if [ ${RESULT} != 0 ];then
                yum install -y dos2unix
        fi
fi

tmpFileName="giipTmpScript.sh"
tmpFileName2="giipTmpScript2.sh"
logdt=`date '+%Y/%m/%d %H:%M:%S'`
Today=`date '+%Y%m%d'`

wget -O $tmpFileName2 "http://giip.littleworld.net/api/cqe/queue/get03?sk=$sk&lssn=$lssn&os=$os&df=os"

echo "[$logdt]" >> giipAgent.log

ls -l $tmpFileName
cat $tmpFileName2 |tr -d '\r'> $tmpFileName

while [ -s $tmpFileName ];
do

        n=`sed -n '/\/expect/=' giipTmpScript.sh`
        if [[ $n -eq 1 ]]; then
                expect ./giipTmpScript.sh >> giipAgent.log
                echo "Executed expect script..." >> giipAgent.log
        else
                sh ./giipTmpScript.sh >> giipAgent.log
                echo "Executed script..." >> giipAgent.log
        fi


        wget -O $tmpFileName2 "http://giip.littleworld.net/api/cqe/queue/get03?sk=$sk&lssn=$lssn&os=$os&df=os"
        ls -l $tmpFileName
        cat $tmpFileName2 |tr -d '\r' > $tmpFileName
done

rm -f $tmpFileName
