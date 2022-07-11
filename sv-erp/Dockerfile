FROM nginx:1.21.6-alpine
COPY ./sv-erp-vben/dist/ /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d

ARG timezone

ENV TIMEZONE=${timezone:-"Asia/Shanghai"}

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache gcc g++ make unixodbc-dev php7 php7-redis php7-iconv \
    php7-pear php7-phar php7-pdo_mysql php7-openssl php7-pdo php7-dev \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /bin/composer \
    && pecl install swoole sqlsrv pdo_sqlsrv \
    && curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.7.2.1-1_amd64.apk \
    && curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.7.1.1-1_amd64.apk \
    && apk add --allow-untrusted msodbcsql17_17.7.2.1-1_amd64.apk \
    && apk add --allow-untrusted mssql-tools_17.7.1.1-1_amd64.apk \
    && rm -rf *.apk \
    #  ---------- some config ----------
    && cd /etc/php7 \
    # - config PHP
    && { \
        echo "upload_max_filesize=128M"; \
        echo "post_max_size=128M"; \
        echo "memory_limit=1G"; \
        echo "date.timezone=${TIMEZONE}"; \
        echo "extension=swoole"; \
        echo "extension=sqlsrv"; \
        echo "extension=pdo_sqlsrv"; \
        echo "swoole.shotname=Off"; \
    } | tee conf.d/99_overrides.ini \
    # - config timezone
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    # ---------- clear works ----------
    && apk del gcc g++ autoconf make \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

WORKDIR /opt/www

COPY ./sv-erp-hyperf /opt/www
RUN composer install --no-dev -o && php bin/hyperf.php

CMD ["sh", "-c", "nginx -c /etc/nginx/nginx.conf && php /opt/www/bin/hyperf.php start"]