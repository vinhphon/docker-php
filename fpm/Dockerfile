ARG VERSION=8.2
FROM php:${VERSION}-fpm-alpine

LABEL maintainer="admin@iamphon.com"
LABEL repo="https://github.com/vinhphon/docker-php"

ARG UID=1000
ARG GID=1000
ARG SOURCE_ROOT=/var/www/html
ARG EXTENSIONS="bcmath bz2 calendar exif gd gettext intl mysqli opcache pdo_mysql redis soap sockets sodium sysvmsg sysvsem sysvshm xsl zip pcntl"

ENV PHP_MEMORY_LIMIT 2G
ENV PHP_VALIDATE_TIMESTAMPS 1
ENV UPLOAD_MAX_FILESIZE 128M
ENV POST_MAX_SIZE 128M

#Install install-php-extensions
ADD https://raw.githubusercontent.com/vinhphon/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

#Install extensions
RUN set -eux; \
    chmod +x /usr/local/bin/install-php-extensions; \
    IPE_GD_WITHOUTAVIF=1 IPE_ICU_EN_ONLY=1 install-php-extensions ${EXTENSIONS}

#Install lib for docker-php-ext-enable
RUN set -eux; \
    apk add --no-cache --virtual .build-deps binutils; \
    cp /usr/bin/readelf /usr/local/bin/readelf; \
    if [ -f /usr/lib/libctf-nobfd.so.0 ]; then cp /usr/lib/libctf-nobfd.so.0 /usr/local/lib/libctf-nobfd.so.0; fi ;\
    if [ -f /usr/lib/libsframe.so.0 ]; then cp /usr/lib/libsframe.so.0 /usr/local/lib/libsframe.so.0; fi ;\
    apk del --no-network .build-deps;

#Copy config
COPY php.ini                /usr/local/etc/php/conf.d/zz-custom.ini
COPY www.conf               /usr/local/etc/php-fpm.d/zz-custom.conf
COPY docker-entrypoint  /usr/local/bin/

#Permission www
RUN set -eux; \
    mkdir -p ${SOURCE_ROOT} /var/www/log; \
    addgroup -S -g ${UID} www; \
    adduser -S -D -u ${GID} -s /sbin/nologin -h /var/www -G www www; \
    chown -R www:www /usr/local/etc/php/conf.d /var/www /var/www/log ${SOURCE_ROOT}; \
    chmod +x /usr/local/bin/docker-entrypoint;

WORKDIR ${SOURCE_ROOT}

#Switch container run as non-root
USER www

ENTRYPOINT ["docker-entrypoint"]

CMD ["php-fpm", "-R"]