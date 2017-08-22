#epel repo insall and nginx install
yum -y install epel-release
yum -y install nginx
yum -y install vim

#nginx restart
systemctl restart nginx 
systemctl enable nginx

#Webtatic repository install + php package install
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm 
yum install -y php71w php71w-curl php71w-common php71w-cli php71w-mysql php71w-mbstring php71w-fpm php71w-xml php71w-pdo php71w-zip

#php-fpm config
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini
sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/listen = 127.0.0.1:9000/listen = \/run\/php-fpm\/php-fpm.sock/g' /etc/php-fpm.d/www.conf
sed -i 's/;listen.owner = nobody/listen.owner = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/;listen.group = nobody/listen.group = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php-fpm.d/www.conf
sed -i 's/;env\[HOSTNAME\] = \$HOSTNAME/env\[HOSTNAME\] = \$HOSTNAME/g' /etc/php-fpm.d/www.conf
sed -i 's/;env\[PATH\] = \/usr\/local\/bin:\/usr\/bin:\/bin/env[PATH] = \/usr\/local\/bin:\/usr\/bin:\/bin/g' /etc/php-fpm.d/www.conf
sed -i 's/;env\[TMP\] = \/tmp/env\[TMP\] = \/tmp/g' /etc/php-fpm.d/www.conf
sed -i 's/;env\[TMPDIR\] = \/tmp/env\[TMPDIR\] = \/tmp/g' /etc/php-fpm.d/www.conf
sed -i 's/;env\[TEMP\] = \/tmp/env\[TEMP\] = \/tmp/g' /etc/php-fpm.d/www.conf


#php-fpm restart
systemctl restart php-fpm 
systemctl enable php-fpm 
netstat -pl | grep php-fpm.sock 
systemctl restart nginx

#mariadb installing and restart
yum -y install mariadb mariadb-server
systemctl start mariadb
systemctl enable mariadb

#add web ports
firewall-cmd --permanent --zone=public --add-service=http 
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

#recently network info
yum -y install net-tools
netstat -plntu

#checking your install info.
rpm -qa mairadb
rpm -qa nginx
php -v 
