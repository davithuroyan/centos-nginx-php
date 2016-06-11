FROM centos:latest

MAINTAINER Cameron Waldron <cameron.waldron@gmail.com>

RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install nginx php php-fpm git && \
    yum clean all && \
    sed -i '/;cgi.fix_pathinfo=1/c\cgi.fix_pathinfo=0' /etc/php.ini && \
    sed -i '/listen = 127.0.0.1:9000/c\listen = /var/run/php-fpm/php-fpm.sock' /etc/php-fpm.d/www.conf && \
    sed -i '/;listen.owner = nobody/c\listen.owner = nobody' /etc/php-fpm.d/www.conf && \
    sed -i '/;listen.group = nobody/c\listen.group = nobody' /etc/php-fpm.d/www.conf && \
    sed -i '/user = apache/c\user = nginx' /etc/php-fpm.d/www.conf && \
    sed -i '/group = apache/c\group = nginx' /etc/php-fpm.d/www.conf && \
    yum -y install python-setuptools && \
    easy_install supervisor && \
    echo $'[supervisord]\n\
logfile=/dev/null\n\
pidfile=/var/run/supervisord.pid\n\
nodaemon=true\n\
\n\
[unix_http_server]\n\
file=/tmp/supervisor.sock\n\
\n\
[supervisorctl]\n\
serverurl=unix:///tmp/supervisor.sock\n\
\n\
[program:nginx]\n\
command=nginx -g "daemon off;"\n\
redirect_stderr=true\n\
stdout_logfile=/dev/stdout\n\
stdout_logfile_maxbytes=0\n\
auto_start=true\n\
autorestart=true\n\
\n\
[program:php-fpm]\n\
command=php-fpm\n\
redirect_stderr=true\n\
stdout_logfile=/dev/stdout\n\
stdout_logfile_maxbytes=0\n\
auto_start=true\n\
autorestart=true\n'\
>> /etc/supervisord.conf && \
    mkdir /root/scripts && \
    echo $'#!/bin/bash\n\
function clone {\n\
  git clone $1 /root/app\n\
}\n\
if (( $# != 1 ))\n\
then\n\
  echo "Usage: get [GIT REPO PATH]"\n\
  exit 1\n\
fi\n\
if clone $1; then\n\
  /root/app/scripts/publish.sh\n\
fi'\
>> /root/scripts/get && \
    echo $'#!/bin/bash\n\
function pull {\n\
  cd /root/app\n\
  git pull\n\
}\n\
if pull; then\n\
  /root/app/scripts/publish.sh\n\
fi'\
>> /root/scripts/update && \
    chmod u+x /root/scripts/update && \
    chmod u+x /root/scripts/get
ENV PATH /root/scripts:$PATH
EXPOSE 80 443
CMD ["supervisord"]
