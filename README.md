## Build

'''
docker build -t processmaker:latest https://github.com/rossonet/docker-apache.git
'''

## Run

'''
mkdir processmaker-data
export PMOS_URL=localhost
docker run -p 8080:8080 -v $(pwd)/processmaker-data:/opt -e URL=$PMOS_URL processmaker:latest
'''
