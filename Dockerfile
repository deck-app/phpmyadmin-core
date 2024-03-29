FROM alpine:3.12

ENV PHPMYADMIN_VERSION 5.1.3

ENV PHPMYADMIN_DIR /usr/share/webapps/phpmyadmin/
ENV PHPMYADNIN_PACKAGE phpMyAdmin-$PHPMYADMIN_VERSION-english
ENV PHPMYADMIN_DOWNLOAD https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION/$PHPMYADNIN_PACKAGE.tar.gz

ENV REQUIRED_PACKAGES \
  apache2 \
  php7 \
  php7-apache2 \
  php7-bz2 \
  php7-ctype \
  php7-gd \
  php7-json \
  php7-mbstring \
  php7-mcrypt \
  php7-mysqli \
  php7-openssl \
  php7-session \
  php7-zip \
  php7-zlib \
  wget

RUN \
  apk add -U --no-cache $REQUIRED_PACKAGES 

RUN \
  mkdir -p /usr/share/webapps && \
  cd /tmp && \
  wget -q -O - $PHPMYADMIN_DOWNLOAD | tar xzf - && \
  mv $PHPMYADNIN_PACKAGE $PHPMYADMIN_DIR && \
  rm -fr $PHPMYADMIN_DIR/{setup,config.sample.inc.php} && \
  chown -R apache:apache $PHPMYADMIN_DIR && \
  echo "Done"

ADD config.inc.php $PHPMYADMIN_DIR
ADD config.secret.inc.php $PHPMYADMIN_DIR
ADD config.user.inc.php $PHPMYADMIN_DIR
ADD phpmyadmin.conf /etc/apache2/conf.d/
ADD httpd.conf /etc/apache2/
RUN chmod +x /etc/apache2/httpd.conf
# RUN chmod +x /var/www/localhost/htdocs/config.inc.php

RUN mkdir -p /run/apache2

WORKDIR $PHPMYADMIN_DIR

EXPOSE 80
ADD index.html /var/www/localhost/htdocs/
RUN chmod +x /var/www/localhost/htdocs/index.html

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]