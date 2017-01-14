FROM centos:7

MAINTAINER Tao Guo <guotao945@gmail.com>

#RUN yum update
#Apache
RUN yum -y install httpd

#Mysql
RUN yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
RUN yum -y install mysql-community-server

#Php7
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

RUN yum install -y php71w
RUN yum install -y \
    php71w-mbstring \
    php71w-mysqlnd \
    php71w-intl \
    php71w-pdo \
    php71w-pear \
    php71w-opcache \
    php71w-soap \
    php71w-xml \
    php71w-pecl-xdebug \
    php71w-pecl-imagick \
    php71w-pecl-apcu \
    php71w-gd

#config
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
    && echo "NETWORKING=yes" > /etc/sysconfig/network
    
RUN sed -i \
    -e 's~^ServerSignature On$~ServerSignature Off~g' \
    -e 's~^ServerTokens OS$~ServerTokens Prod~g' \
    -e 's~^#ExtendedStatus On$~ExtendedStatus On~g' \
    -e 's~^DirectoryIndex \(.*\)$~DirectoryIndex \1 index.php~g' \
    -e 's~^NameVirtualHost \(.*\)$~#NameVirtualHost \1~g' \
    /etc/httpd/conf/httpd.conf

RUN sed -i \
    -e 's~^IndexOptions \(.*\)$~#IndexOptions \1~g' \
    -e 's~^IndexIgnore \(.*\)$~#IndexIgnore \1~g' \
    -e 's~^AddIconByEncoding \(.*\)$~#AddIconByEncoding \1~g' \
    -e 's~^AddIconByType \(.*\)$~#AddIconByType \1~g' \
    -e 's~^AddIcon \(.*\)$~#AddIcon \1~g' \
    -e 's~^DefaultIcon \(.*\)$~#DefaultIcon \1~g' \
    -e 's~^ReadmeName \(.*\)$~#ReadmeName \1~g' \
    -e 's~^HeaderName \(.*\)$~#HeaderName \1~g' \
    /etc/httpd/conf/httpd.conf

RUN sed -i \
    -e 's~^LanguagePriority \(.*\)$~#LanguagePriority \1~g' \
    -e 's~^ForceLanguagePriority \(.*\)$~#ForceLanguagePriority \1~g' \
    -e 's~^AddLanguage \(.*\)$~#AddLanguage \1~g' \
    /etc/httpd/conf/httpd.conf
    
RUN sed -i \
    -e 's~^\(LoadModule .*\)$~#\1~g' \
    -e 's~^#LoadModule mime_module ~LoadModule mime_module ~g' \
    -e 's~^#LoadModule log_config_module ~LoadModule log_config_module ~g' \
    -e 's~^#LoadModule setenvif_module ~LoadModule setenvif_module ~g' \
    -e 's~^#LoadModule status_module ~LoadModule status_module ~g' \
    -e 's~^#LoadModule authz_host_module ~LoadModule authz_host_module ~g' \
    -e 's~^#LoadModule dir_module ~LoadModule dir_module ~g' \
    -e 's~^#LoadModule alias_module ~LoadModule alias_module ~g' \
    -e 's~^#LoadModule expires_module ~LoadModule expires_module ~g' \
    -e 's~^#LoadModule deflate_module ~LoadModule deflate_module ~g' \
    -e 's~^#LoadModule headers_module ~LoadModule headers_module ~g' \
    -e 's~^#LoadModule alias_module ~LoadModule alias_module ~g' \
    /etc/httpd/conf/httpd.conf

RUN sed -i \
    -e 's~^;date.timezone =$~date.timezone = Asia/Shanghai~g' \
    -e 's~^;user_ini.filename =$~user_ini.filename =~g' \
    -e 's~^sendmail_path = /usr/sbin/sendmail -t -i$~sendmail_path = /usr/bin/msmtp -C /etc/msmtprc -t -i~g' \
    /etc/php.ini

RUN echo '<?php phpinfo(); ?>' > /var/www/html/index.php

#Purge
RUN yum clean all
RUN rm -rf /sbin/sln \
    ; rm -rf /usr/{{lib,share}/locale,share/{man,doc,info,gnome/help,cracklib,il8n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
    ; rm -rf /var/cache/{ldconfig,yum}/*

EXPOSE 80 443 3306

RUN systemctl enable httpd
RUN systemctl enable mysqld

CMD ["/usr/sbin/init"]
