# Base Image
FROM amazonlinux:2018.03
#FROM centos:7.9.2009
CMD ["/bin/bash"]

# Extra
LABEL version="3.5.4"
LABEL description="ProcessMaker 3.5.4 Comunity Docker Container - Apache"

# Declare ARG and ENV Variables
ARG URL
ENV URL $URL

# Initial steps
RUN yum clean all && yum install epel-release -y && yum update -y

# Required packages
RUN yum install \
  gcc \
  wget \
  nano \
  sendmail \
  libmcrypt-devel \
  httpd24 \
  mysql57 \
  php73 \
  php73-devel \
  php73-opcache \
  php73-gd \
  php73-mysqlnd \
  php73-soap \
  php73-mbstring \
  php73-ldap \
  php7-pear \
  hostname \
  -y

#RUN cp /etc/hosts ~/hosts.new && sed -i "/127.0.0.1/c\127.0.0.1 localhost localhost.localdomain `hostname`" ~/hosts.new && cp -f ~/hosts.new /etc/hosts

RUN echo '' | pecl7 install mcrypt
  
# Download ProcessMaker Enterprise Edition from Rossonet cache
RUN wget -O "/tmp/processmaker-3.5.4.tar.gz" \
      "https://www.rossonet.net/dati/pmos/processmaker-3.5.4-community.tar.gz"
	  
# Copy configuration files
COPY pmos.conf /etc/httpd/conf.d
RUN mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bk
COPY httpd.conf /etc/httpd/conf

# ProcessMaker required configurations
RUN sed -i '/memory_limit = 128M/c\memory_limit = 512M' /etc/php.ini && \
sed -i '/short_open_tag = Off/c\short_open_tag = On' /etc/php.ini && \
sed -i '/post_max_size = 8M/c\post_max_size = 24M' /etc/php.ini && \
sed -i '/upload_max_filesize = 2M/c\upload_max_filesize = 24M' /etc/php.ini && \
sed -i '/;date.timezone =/c\date.timezone = America/New_York' /etc/php.ini && \
sed -i '/expose_php = On/c\expose_php = Off' /etc/php.ini && \
echo 'extension=mcrypt.so' >> /etc/php.ini

# OpCache configurations
RUN sed -i '/;opcache.enable_cli=0/c\opcache.enable_cli=1' /etc/php.d/10-opcache.ini && \
sed -i '/opcache.max_accelerated_files=4000/c\opcache.max_accelerated_files=10000' /etc/php.d/10-opcache.ini && \
sed -i '/;opcache.max_wasted_percentage=5/c\opcache.max_wasted_percentage=5' /etc/php.d/10-opcache.ini && \
sed -i '/;opcache.use_cwd=1/c\opcache.use_cwd=1' /etc/php.d/10-opcache.ini && \
sed -i '/;opcache.validate_timestamps=1/c\opcache.validate_timestamps=1' /etc/php.d/10-opcache.ini && \
sed -i '/;opcache.fast_shutdown=0/c\opcache.fast_shutdown=1' /etc/php.d/10-opcache.ini

# Apache Ports
EXPOSE 8080

# Docker entrypoint
COPY docker-entrypoint.sh /bin/
RUN chmod a+x /bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
