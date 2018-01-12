FROM debian:jessie
MAINTAINER Diego Gomes de Sá <gomesdiego580@gmail.com>

RUN echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list && \
    echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list
RUN apt-get update && apt-get install wget --yes
RUN wget https://www.dotdeb.org/dotdeb.gpg | apt-key add dotdeb.gpg

RUN apt-get update && apt-get install --quiet --yes --force-yes --no-install-recommends \
    php7.0-fpm \
    php7.0-gd \
    php7.0-imagick \
    php7.0-mbstring \
    php7.0-zip \
    php7.0-soap \
    php7.0-imap \
    php7.0-mcrypt \
    nginx-full \
    supervisor

ADD nginx/default /etc/nginx/sites-enabled/default

ADD public_html/* /var/www/html/

RUN echo 'listen = 127.0.0.1:9000' >> /etc/php/7.0/fpm/pool.d/www.conf

#RUN systemctl enable nginx && systemctl enable php7.0-fpm
#RUN /etc/init.d/php7.0-fpm start

RUN echo "[supervisord]" >> /etc/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisord.conf && \
    echo "" >> /etc/supervisord.conf && \
    echo "[program:php-fpm7.0]" >> /etc/supervisord.conf && \
    echo "command=/usr/sbin/php-fpm7.0" >> /etc/supervisord.conf && \
    echo "" >> /etc/supervisord.conf && \
    echo "[program:nginx]" >> /etc/supervisord.conf && \
    echo "command=/usr/sbin/nginx" >> /etc/supervisord.conf && \
    echo "" >> /etc/supervisord.conf



EXPOSE 80

#CMD /etc/init.d/nginx start && \
#    /etc/init.d/php7.0-fpm start && \
#    /bin/bash

#CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
