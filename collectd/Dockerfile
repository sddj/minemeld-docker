FROM centos:7
RUN yum install -y epel-release
RUN yum install -y collectd collectd-rrdtool socat
COPY collectd.conf /etc/collectd.conf
COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT /bin/entrypoint.sh
