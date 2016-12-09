FROM centos:7

MAINTAINER Tao Guo <guotao945@gmail.com>

RUN yum -y install \
    httpd

EXPOSE 80 443
