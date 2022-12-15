FROM ubuntu:20.04
LABEL description="ProcessMaker 4 - Community Edition"

ARG URL
ENV URL $URL
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC
ENV DOCKERVERSION=20.10.5

RUN apt update

RUN apt install -y php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl \
    php-xml php-pear php-bcmath php-imagick php-dom php-sqlite3 vim curl unzip wget supervisor cron \
    mysql-client build-essential wget iputils-ping \
    nginx \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt -y install nodejs
RUN wget -O composer-setup.php https://getcomposer.org/installer
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN composer self-update

COPY laravel-cron /etc/cron.d/laravel-cron
RUN chmod 0644 /etc/cron.d/laravel-cron && crontab /etc/cron.d/laravel-cron

RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
    && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
    && rm docker-${DOCKERVERSION}.tgz

RUN mkdir -p /code && wget -q -O "/tmp/processmaker.tar.gz" "https://github.com/ProcessMaker/processmaker/archive/refs/tags/v4.2.36.tar.gz" \
    && cd /code/ \
    && tar -xzf /tmp/processmaker.tar.gz \
    && mv processmaker-* pm4 \
    && cd pm4 \
    && composer install \ 
    && rm /tmp/processmaker.tar.gz

WORKDIR /code/pm4

EXPOSE 80 6001

COPY docker-entrypoint.sh /code/pm4/docker-entrypoint.sh 
COPY services.conf /etc/supervisor/conf.d/services.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY laravel-echo-server.json /code/pm4/laravel-echo-server.json
RUN sed -i 's/www-data/root/g' /etc/php/7.4/fpm/pool.d/www.conf
RUN npm install --unsafe-perm=true && npm run dev

ENTRYPOINT /code/pm4/docker-entrypoint.sh
