crontab -l
(crontab -l ; echo "# 160701 Lowy, for giip")| crontab -
(crontab -l ; echo "* * * * * bash --login -c 'sh /usr/local/giip/scripts/giipAgent.sh'")| crontab -
crontab -l

mkdir -p /usr/local/giip/scripts
vi /usr/local/giip/scripts/giipAgent.sh
