FROM centos:7
RUN yum install -y epel-release
RUN yum install -y collectd collectd-rrdtool
COPY collectd.conf /etc/collectd.conf
