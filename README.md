# ProcessMaker with Apache httpd
[![Build and publish docker image to DockerHub](https://github.com/rossonet/ProcessMaker-apache/actions/workflows/publish-to-dockerhub.yml/badge.svg)](https://github.com/rossonet/ProcessMaker-apache/actions/workflows/publish-to-dockerhub.yml)
[![Build and publish docker image to GitHub Registry](https://github.com/rossonet/ProcessMaker-apache/actions/workflows/publish-to-github-registry.yml/badge.svg)](https://github.com/rossonet/ProcessMaker-apache/actions/workflows/publish-to-github-registry.yml)

## Build from the Github repository

```
docker build -t rossonet/processmaker-apache:latest https://github.com/rossonet/ProcessMaker-apache.git
```

## Run with Docker

1. create the bridge network
```
docker network create --driver bridge pmos-net
```

2. create the Mysql database
```
mkdir mysql-data
docker run -d --rm --name mysql-db -v $(pwd)/mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw --network pmos-net mysql:5
```

3. create the Processmaker instance
```
mkdir processmaker-data
export PMOS_URL=localhost
docker run -d --rm --name pmos -p 8080:8080 -v $(pwd)/processmaker-data:/opt -e URL=$PMOS_URL --network pmos-net rossonet/processmaker-apache:latest
```

4. configure ProcessMaker

open the link http://localhost:8080 in the browser. Should appear a page with the dependencies check.

![Installation page 1](https://raw.githubusercontent.com/rossonet/ProcessMaker-apache/master/imgs/page_one.png)

go to the "Next" page.

![Installation page 2](https://raw.githubusercontent.com/rossonet/ProcessMaker-apache/master/imgs/page_two.png)

Next

![Installation page 3](https://raw.githubusercontent.com/rossonet/ProcessMaker-apache/master/imgs/page_three.png)

agree to the license of ProcessMaker, rember is a GNU AFFERO GENERAL PUBLIC LICENSE and click Next

![Installation page 4](https://raw.githubusercontent.com/rossonet/ProcessMaker-apache/master/imgs/page_four.png)

fill the password field, in our case my-secret-pw, and the "Host Name" with mysql-db than click on "Test Connection" and Next 

![Installation page 5](https://raw.githubusercontent.com/rossonet/ProcessMaker-apache/master/imgs/page_five.png)

set the admin password, click on "Check Workspace Configuration" and "Finish"

![Installation completed](https://raw.githubusercontent.com/rossonet/ProcessMaker-apache/master/imgs/page_six.png)

click on "OK"

5. login to ProcessMaker

go to http://localhost:8080/sysworkflow/en/neoclassic/login/login

![Login](https://raw.githubusercontent.com/rossonet/ProcessMaker-apache/master/imgs/login.png)

### Project sponsor 

[![Rossonet s.c.a r.l.](https://raw.githubusercontent.com/rossonet/images/main/artwork/rossonet-logo/png/rossonet-logo_280_115.png)](https://www.rossonet.net)

