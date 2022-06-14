# ProcessMaker with Apache reverse proxy
[![Build and publish docker image to DockerHub](https://github.com/rossonet/ProcessMaker-apache/actions/workflows/publish-to-dockerhub.yml/badge.svg)](https://github.com/rossonet/ProcessMaker-apache/actions/workflows/publish-to-dockerhub.yml)
[![Build and publish docker image to GitHub Registry](https://github.com/rossonet/ProcessMaker-apache/actions/workflows/publish-to-github-registry.yml/badge.svg)](https://github.com/rossonet/ProcessMaker-apache/actions/workflows/publish-to-github-registry.yml)

## Build

```
docker build -t processmaker:latest https://github.com/rossonet/ProcessMaker-apache.git
```

## Run

```
mkdir processmaker-data
export PMOS_URL=localhost
docker run -d -p 8080:8080 -v $(pwd)/processmaker-data:/opt -e URL=$PMOS_URL processmaker:latest
```
