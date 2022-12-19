#!/bin/bash
set -ex

if [ ! -f /opt/processmaker/docker.configured ]
then
	echo "First start of ProcessMaker"
	# Decompress ProcessMaker
	cd /tmp && tar -C /opt -xzvf processmaker-3.5.6.tar.gz
	chown -R apache. /opt/processmaker
	# Set Apache server_name
	sed -i 's,ServerName server.processmaker.net,ServerName '"${URL}"',g' /etc/httpd/conf.d/pmos.conf
	date > /opt/processmaker/docker.configured
else
	echo "The configuration of Processmaker exists"
fi

# Start services
cp /etc/hosts ~/hosts.new
sed -i "/127.0.0.1/c\127.0.0.1 localhost localhost.localdomain `hostname`" ~/hosts.new
cp -f ~/hosts.new /etc/hosts
chkconfig sendmail on && service sendmail start
touch /etc/sysconfig/network
sed -i "s/'default' => env('QUEUE_CONNECTION', 'database'),/'default' => env('QUEUE_CONNECTION', 'sync'),/" /opt/processmaker/config/queue.php
chkconfig httpd on && /usr/sbin/httpd -D FOREGROUND
