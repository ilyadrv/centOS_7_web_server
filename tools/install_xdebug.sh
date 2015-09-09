#!/bin/bash

echo "install Xdebug"

pecl install Xdebug

echo -n "Profiler Output Dir [/var/log/xdebug_profiler]:"
read profiler_output_dir
if [ "$profiler_output_dir" == '' ]; then
profiler_output_dir="/var/log/xdebug_profiler"
fi

mkdir -p profiler_output_dir

cat <<EOF > /etc/php.d/xdebug.ini
zend_extension=xdebug.so;
xdebug.remote_enable=1;
xdebug.remote_port="9000";
xdebug.profiler_enable=1;
xdebug.remote_connect_back=1;
xdebug.profiler_enable = 0;
xdebug.profiler_enable_trigger = 1;
xdebug.profiler_output_dir = $profiler_output_dir;
xdebug.profiler_output_name = "xdp.%t"
EOF
echo "Write /etc/php.d/xdebug.ini:"
cat /etc/php.d/xdebug.ini

echo ""
echo "restart apache"
systemctl restart httpd

echo ""
echo "XDEBUG: " $(php --ri xdebug | grep -i "version")