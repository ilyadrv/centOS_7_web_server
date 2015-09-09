#!/bin/bash
source $( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"/scripts/settings.sh"

echo "***********************************************"
echo "***********************************************"
echo "***   Configure Web Server   *******"
echo "***********************************************"
echo "***********************************************"
echo "This script is intended to:"
echo " 1. Configure Apache"
echo " 2. Configure Hosts"
echo "***********************************************"

#configure apache
echo ""
if $REMOVE_FILES_ROOT; then
    echo "remove $FILES_ROOT"
    rm -rf $FILES_ROOT
fi

echo "create $DOC_ROOT"
mkdir -p $DOC_ROOT

echo ""
echo "put VirtualHost congiguration to /etc/httpd/conf.d/hosts.conf:"
echo "- ServerName $WEB_DOMAIN"
echo "- DocumentRoot $DOC_ROOT"
cat <<EOF > /etc/httpd/conf.d/hosts.conf
NameVirtualHost *:80
NameVirtualHost *:443

<VirtualHost *:80>
    DocumentRoot $DOC_ROOT
    ServerName $WEB_DOMAIN
    ServerAlias www.$WEB_DOMAIN
    ServerAdmin $SERVER_ADMIN
    ErrorLog /var/log/httpd/$WEB_DOMAIN-error_log
    CustomLog /var/log/httpd/$WEB_DOMAIN-access_log common

    RewriteEngine on
    # rewrite to https
    RewriteCond %{SERVER_PORT} !=443
    RewriteCond %{REQUEST_URI} !^/public/.*$ [NC]
    RewriteRule ^(.*) https://%{SERVER_NAME}%{REQUEST_URI}
</VirtualHost>

<VirtualHost *:443>
    DocumentRoot $DOC_ROOT
    ServerName $WEB_DOMAIN
    ServerAlias www.$WEB_DOMAIN
    ServerAdmin $SERVER_ADMIN
    SSLEngine on
    SSLProtocol all -SSLv2
    SSLCertificateFile /etc/pki/tls/certs/localhost.crt
    SSLCertificateKeyFile /etc/pki/tls/private/localhost.key
    SSLCipherSuite DEFAULT:!EXP:!SSLv2:!DES:!IDEA:!SEED:+3DES

    RewriteEngine on

    #Rewrite URL for lazy url
    RewriteCond %{HTTP_HOST} ^duo$ [NC]
    RewriteRule ^(.*) https://$WEB_DOMAIN%{REQUEST_URI} [L]

    # redirect simple /gwusers/*_users files
    RewriteRule ^/gwusers/([A-Z0-9]*_users)$ /gwfiles/$1 [PT]

    #shortcuts
    RewriteRule ^/duo/eor/(.*) /duo/user_feedback.php$1 [R]
    RewriteRule ^/duo/cal[\/]*$ /duo/public_calendar.php [R]
    RewriteRule ^/duo/badge[\/]*$ /duo/user_get_badge.php [R]
    RewriteRule ^/duo/cpt[\/]*$ /duo/user_get_badge.php?CPT=Y [R]
    RewriteRule ^/duo/er[\/]*$ /duo/user_expreport.php$1 [R]
    RewriteRule ^/duo/signup[\/]*$ /duo/user_reg.php$1 [R]
    RewriteRule ^/duo/publications[\/]*$ /duo/user_publication_list.php$1 [R]
    RewriteRule ^/duo/login[\/]*$ /duo/switch_admin.php$1 [R]

    Alias /pdf/ $FILES_ROOT/pdf/
    Alias /doc/ $FILES_ROOT/doc/
    Alias /gwfiles/ $FILES_ROOT/gwusers/
    Redirect /duo/shib      https://$WEB_DOMAIN/Shibboleth.sso/Login?target=https://$WEB_DOMAIN/duo/&isPassive=false

    ErrorLog /var/log/httpd/$WEB_DOMAIN-error_log
    CustomLog /var/log/httpd/$WEB_DOMAIN-access_log common
</VirtualHost>


<Directory $DOC_ROOT >
    Options  FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOF

rm -f /etc/httpd/conf.d/welcome.conf

#restart apache
echo ""
echo "restart apache"
systemctl restart httpd