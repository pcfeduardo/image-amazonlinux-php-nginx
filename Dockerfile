FROM amazonlinux:2

# php settings
ENV PHP_FPM_USER "nginx"
ENV PHP_FPM_GROUP "nginx"
ENV PHP_FPM_LISTEN_MODE "0660"
ENV PHP_MEMORY_LIMIT "512M"
ENV PHP_MAX_UPLOAD "50M"
ENV PHP_MAX_FILE_UPLOAD "200"
ENV PHP_MAX_POST "100M"
ENV PHP_DISPLAY_ERRORS "On"
ENV PHP_DISPLAY_STARTUP_ERRORS "On"
ENV PHP_ERROR_REPORTING "E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
ENV PHP_CGI_FIX_PATHINFO 0
ENV PHP_INI_FILE "/etc/php.ini"
ENV PHP_FPM_FILE "/etc/php-fpm.d/www.conf"

# basics
RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    yum update -y && yum upgrade -y && \
    amazon-linux-extras install epel -y && \
    yum install nginx -y && \
    amazon-linux-extras enable php7.4 && \
    yum install -y php-intl php-fpm php-cli php-mbstring php-pdo php-gd php-pdo_mysql php-mysqlnd php-json php-phar php-tokenizer php-xmlwriter php-simplexml php-dom php-xml php-session php-pdo_sqlite php-sqlite3 php-curl php-mysqli && \
    yum clean all -y && rm -rf /var/cache/yum/*

# php.ini
RUN sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" ${PHP_INI_FILE} \
    && sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" ${PHP_INI_FILE} \
    && sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" ${PHP_INI_FILE} \
    && sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" ${PHP_INI_FILE} \
    && sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" ${PHP_INI_FILE} \
    && sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" ${PHP_INI_FILE} \
    && sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" ${PHP_INI_FILE} \
    && sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" ${PHP_INI_FILE}

# php-fpm
RUN sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" ${PHP_FPM_FILE} \
    && sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" ${PHP_FPM_FILE} \
    && sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" ${PHP_FPM_FILE} \
    && sed -i "s|user\s*=\s*apache|user = ${PHP_FPM_USER}|g" ${PHP_FPM_FILE} \
    && sed -i "s|group\s*=\s*apache|group = ${PHP_FPM_GROUP}|g" ${PHP_FPM_FILE} \
    && sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" ${PHP_FPM_FILE} \
    && sed -i 's/include\ \=\ \/etc\/php7\/php-fpm.d\/\*.conf/\;include\ \=\ \/etc\/php7\/php-fpm.d\/\*.conf/g' ${PHP_FPM_FILE} \
    && sed -i "s|;clear_env|clear_env|g" ${PHP_FPM_FILE}

# logs
RUN ln -s /dev/stdout /var/log/nginx/access.log && \
    ln -s /dev/stderr /var/log/nginx/error.log && \
    ln -s /dev/stderr /var/log/php-fpm/error.log

# wkhtmltopdf
RUN curl -o wkhtmltox.rpm -L https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox-0.12.6-1.amazonlinux2.x86_64.rpm && \
    yum install -y ./wkhtmltox.rpm && \
    ln -s  /usr/local/bin/wkhtmltopdf /usr/bin/wkhtmltopdf && \
    rm -rf wkhtmltox.rpm && yum clean all -y && rm -rf /var/cache/yum/*

EXPOSE 80