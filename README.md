
[![Docker Hub pulls](https://img.shields.io/docker/pulls/vinhphon/php?style=for-the-badge)](https://hub.docker.com/r/vinhphon/php)

Dockerfiles PHP cli and fpm built in official PHP Docker Alpine images (Supported PHP 5.6->8.x) with installed extensions with possible smallest size.

## Features

- PHP extensions installed via the [mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer) tool, allowing you to easily add php extensions with redundant lib, keep layer smallest.
- Run as non-root user for improved security. (www UID=1000/GID=1000)
- Rootless crontab for running cron jobs without requiring root privileges on cli images
- Enable cron and installed extensions via env PHP_EXTENSIONS and CRONTAB
- Trick to run enable extensions without download alpine packages.

## Usage

Supported extensions from [mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer)

1. Built images on docker hub with tags (arm64/amd64):

    - main: vinhphon/php:{version}-cli, vinhphon/php:{version}-fpm
    - dev: vinhphon/php:{version}-dev-cli, vinhphon/php:{version}-dev-fpm

    Installed extension is enabled as by default, you can change enabled by changing env

    ```
    docker run -e PHP_EXTENSIONS="..." -e CRONTAB="..." --rm vinhphon/php:8.2-cli php -m
    ```

2. Rebuild images: 

    Go to cli/fpm folder execute:

    ```bash
    docker build -t your-image-tag \
    --build-arg SOURCE_ROOT="your working dir" \
    --build-arg VERSION="php version" \
    --build-arg EXTENSIONS="extensions, seperate by space" \
    --build-arg COMPOSER_VERSION="composer version (cli)" \
    --build-arg CRONTAB="composer version (cli)" \
    --build-arg UID="userID" \
    --build-arg GID="groupID" .
    ```

3. Extend built images:

    In case you want to add more extension with faster build time, you can ref "dev" branch or refer Dockerfile.cli.extend.sample, Dockerfile.fpm.extend.sample

    Then you can use rebuild command on #1 for.

## Built images php extensions

    * 5.6 -> 7.1: bcmath bz2 calendar dba enchant exif gd gettext gmp imap intl ldap mcrypt mysqli odbc opcache pcntl pdo_mysql pdo_odbc pdo_pgsql pgsql pspell redis shmop snmp soap sockets sodium sysvmsg sysvsem sysvshm tidy xmlrpc xsl zip

    * 7.2 -> 8.x: bcmath bz2 calendar dba enchant exif gd gettext gmp imap intl ldap        mysqli odbc opcache pcntl pdo_mysql pdo_odbc pdo_pgsql pgsql pspell redis shmop snmp soap sockets sodium sysvmsg sysvsem sysvshm tidy xmlrpc xsl zip


## Contributing

Contributions are always welcome! If you'd like to contribute, please open an issue or pull request on the GitHub repository.

## License

This project is licensed under the MIT License.