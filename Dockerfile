FROM alpine:3.16
LABEL maintainer Naba Das <hello@get-deck.com>

ENV RELEASE_DATE 2022-11-16
ENV PHPMYADMIN_VERSION 5.2.0

ENV PHPMYADMIN_DIR /usr/share/webapps/phpmyadmin/
ENV PHPMYADNIN_PACKAGE phpMyAdmin-$PHPMYADMIN_VERSION-english
ENV PHPMYADMIN_DOWNLOAD https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION/$PHPMYADNIN_PACKAGE.tar.gz

ENV REQUIRED_PACKAGES \
  apache2 \
  php8 \
  php8-apache2 \
  php8-bz2 \
  php8-ctype \
  php8-gd \
  php8-json \
  php8-mbstring \
  php8-pecl-mcrypt \
  php8-mysqli \
  php8-openssl \
  php8-session \
  php8-zip \
  bash \
  php8-zlib

RUN \
  apk add -U --no-cache $REQUIRED_PACKAGES && \
  rm /usr/bin/php8

RUN \
  mkdir -p /usr/share/webapps && \
  cd /tmp && \
  wget -q -O - $PHPMYADMIN_DOWNLOAD | tar xzf - && \
  mv $PHPMYADNIN_PACKAGE $PHPMYADMIN_DIR && \
  rm -fr $PHPMYADMIN_DIR/{setup,config.sample.inc.php} && \
  chown -R apache:apache $PHPMYADMIN_DIR && \
  echo "Done"

ADD config.inc.php $PHPMYADMIN_DIR
ADD phpmyadmin.conf /etc/apache2/conf.d/

RUN mkdir -p /run/apache2

WORKDIR $PHPMYADMIN_DIR

EXPOSE 80

ADD entrypoint.sh /
ADD index.html /var/www/localhost/htdocs/
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]