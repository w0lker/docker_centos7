FROM centos:7
MAINTAINER "tangjun" <tangjuncarl@gmail.com>
RUN yum -y update && yum clean all

# set locale
RUN yum reinstall -y glibc-common && yum clean all
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

CMD ["/usr/sbin/init"]
