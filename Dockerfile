FROM centos:latest

MAINTAINER Cameron Waldron <cameron.waldron@gmail.com>

COPY scripts/ /root/scripts/
COPY conf/supervisord.conf /etc/supervisord.conf
ENV PATH /root/scripts:$PATH
EXPOSE 80 443
RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install nginx php php-fpm git logrotate npm && \
    yum clean all && \
    sed -i '/;cgi.fix_pathinfo=1/c\cgi.fix_pathinfo=0' /etc/php.ini && \
    sed -i '/listen = 127.0.0.1:9000/c\listen = /var/run/php-fpm/php-fpm.sock' /etc/php-fpm.d/www.conf && \
    sed -i '/;listen.owner = nobody/c\listen.owner = nobody' /etc/php-fpm.d/www.conf && \
    sed -i '/;listen.group = nobody/c\listen.group = nobody' /etc/php-fpm.d/www.conf && \
    sed -i '/user = apache/c\user = nginx' /etc/php-fpm.d/www.conf && \
    sed -i '/group = apache/c\group = nginx' /etc/php-fpm.d/www.conf && \
    yum -y install python-setuptools && \
    easy_install supervisor && \
	/root/scripts/initialize
CMD ["supervisord"]
