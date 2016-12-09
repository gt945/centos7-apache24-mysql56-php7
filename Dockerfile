FROM centos:7

MAINTAINER Tao Guo <guotao945@gmail.com>

#Apache
RUN yum -y install httpd

#Mysql
RUN yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
RUN yum -y install mysql-community-server

#Php7
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

RUN yum install -y php70w
RUN yum install -y \
    php70w-mbstring \
    php70w-mysqlnd \
    php70w-intl \
    php70w-pdo \
    php70w-pear \
    php70w-opcache \
    php70w-soap \
    php70w-xml \
    php70w-pecl-xdebug \
    php70w-pecl-imagick \
    php70w-gd

EXPOSE 80 443
