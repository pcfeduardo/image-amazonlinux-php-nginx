# image-amazonlinux-php-nginx

## main packages
- nginx (nginx/1.20.1)
- php (php7.4)
- wkhtmltopdf (wkhtmltopdf-0.12.6 - with patched qt)

## logs direction
logfile                     | map to
:-:                         |:-:
/var/log/nginx/access.log   | /dev/stdout
/var/log/nginx/error.log    | /dev/stderr
/var/log/php-fpm/error.log  | /dev/stderr

## php modules
- bz2
- calendar
- Core
- ctype
- curl
- date
- dom
- exif
- fileinfo
- filter
- ftp
- gd
- gettext
- hash
- iconv
- intl
- json
- libxml
- mbstring
- mysqli
- mysqlnd
- openssl
- pcntl
- pcre
- PDO
- pdo_mysql
- pdo_sqlite
- Phar
- readline
- Reflection
- session
- SimpleXML
- sockets
- SPL
- sqlite3
- standard
- tokenizer
- xml
- xmlreader
- xmlwriter
- xsl
- zip
- zlib