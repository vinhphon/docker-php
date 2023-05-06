ARG VERSION=8.2
FROM php:${VERSION}-cli-alpine

LABEL maintainer="admin@iamphon.com"
LABEL repo="https://github.com/vinhphon/docker-php"

ARG UID=1000
ARG GID=1000
ARG SOURCE_ROOT=/var/www/html
ARG COMPOSER_VERSION=2.2.21
ARG EXTENSIONS="bcmath bz2 calendar exif gd gettext intl mysqli opcache pdo_mysql redis soap sockets sodium sysvmsg sysvsem sysvshm xsl zip pcntl"
ARG CRONTAB=""

ENV PHP_MEMORY_LIMIT -1
ENV PHP_MAX_EXECUTION_TIME -1
ENV PHP_VALIDATE_TIMESTAMPS 0
ENV COMPOSER_HOME /var/www/composer

#Install install-php-extensions
ADD https://raw.githubusercontent.com/vinhphon/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

#Install extensions
RUN set -eux; \
    chmod +x /usr/local/bin/install-php-extensions; \
    IPE_GD_WITHOUTAVIF=1 IPE_ICU_EN_ONLY=1 install-php-extensions @composer-${COMPOSER_VERSION} ${EXTENSIONS}

#Install lib for docker-php-ext-enable
RUN set -eux; \
    chmod +x /usr/local/bin/install-php-extensions; \
    apk add --no-cache --virtual .build-deps binutils; \
    cp /usr/bin/readelf /usr/local/bin/readelf; \
    if [ -f /usr/lib/libctf-nobfd.so.0 ]; then cp /usr/lib/libctf-nobfd.so.0 /usr/local/lib/libctf-nobfd.so.0; fi ;\
    apk del --no-network .build-deps;

#Copy config
COPY php.ini                /usr/local/etc/php/conf.d/zz-custom.ini
COPY docker-entrypoint      /usr/local/bin/

#Permission www and cron
RUN set -eux; \
    apk add --no-cache dcron libcap patch; \
    mkdir -p ${SOURCE_ROOT} ${COMPOSER_HOME} /var/www/log; \
    addgroup -S -g ${UID} www; \
    adduser -S -D -u ${GID} -s /sbin/nologin -h /var/www -G www www; \
    touch /var/spool/cron/crontabs/www; \
    chown -R www:www /usr/sbin/crond /var/spool/cron/crontabs/www /usr/local/etc/php/conf.d /var/www /var/www/log ${COMPOSER_HOME} ${SOURCE_ROOT}; \
    chmod +x /usr/local/bin/docker-entrypoint; \
    setcap cap_setgid=ep /usr/sbin/crond;

RUN if [ ! -z "${CRONTAB}" ]; then echo "${CRONTAB}" > /var/spool/cron/crontabs/www ; fi

WORKDIR ${SOURCE_ROOT}

#Switch container run as non-root
USER www

#Copy your app code here
#COPY . .

#Excuting your deployment here, such as: composer install etc...
#RUN set -eux; \
#    composer install; \
#    rm -rf ${COMPOSER_HOME}/cache

ENTRYPOINT ["docker-entrypoint"]

CMD [ "php", "-m" ]