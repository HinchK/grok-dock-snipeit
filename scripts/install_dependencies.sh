#!/bin/bash

# Exit on error
set -o errexit -o pipefail

# Update yum
yum update -y

# Install packages
yum install -y curl
yum install -y git

# Remove current apache & php
#yum -y remove httpd* php*

# Install PHP 7.3
yum install -y php73-xml php73-process php73-bcmath php73-imap \
php73-cli php73-common php73-pdo php73-ldap \
php73-opcache php73-mbstring \
php73-json php73-mysqlnd php73-gd php73 \
php73-fpm

# Install Apache 2.4
#yum -y install httpd24

yum -y install nginx
/sbin/chkconfig nginx on

# Allow URL rewrites
sed -i 's#AllowOverride None#AllowOverride All#' /etc/httpd/conf/httpd.conf

# Change apache document root
mkdir -p /var/www/html/public
sed -i 's#DocumentRoot "/var/www/html"#DocumentRoot "/var/www/html/public"#' /etc/httpd/conf/httpd.conf

# Change apache directory index
sed -e 's/DirectoryIndex.*/DirectoryIndex index.html index.php/' -i /etc/httpd/conf/httpd.conf

# Get Composer, and install to /usr/local/bin
if [ ! -f "/usr/local/bin/composer" ]; then
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php --install-dir=/usr/bin --filename=composer
    php -r "unlink('composer-setup.php');"
else
    /usr/local/bin/composer self-update --stable --no-ansi --no-interaction
fi

# Restart apache
#service httpd start

# Setup apache to start on boot
#chkconfig httpd on

# Start Services
/sbin/chkconfig mysqld on
service mysqld restart

/sbin/chkconfig php-fpm on
service php-fpm restart

/sbin/chkconfig nginx on
service nginx restart

# Ensure aws-cli is installed and configured
if [ ! -f "/usr/bin/aws" ]; then
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
    unzip awscli-bundle.zip
    ./awscli-bundle/install -b /usr/bin/aws
fi

export AWS_ACCOUNT_ID=580254578722
export AWS_DEFAULT_REGION='us-east-2'

# Ensure AWS Variables are available
if [[ -z "$AWS_ACCOUNT_ID" || -z "$AWS_DEFAULT_REGION " ]]; then
    echo "AWS Variables Not Set.  Either AWS_ACCOUNT_ID or AWS_DEFAULT_REGION"
fi
