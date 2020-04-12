# ddagent-centos
Docker image to test various services in containers

## Build the image based on centos 7 with systemd
```
docker build --rm --no-cache -t datadog-centos:1.0 .
```


## Start a container instance to test an app with the datadog agent
```
export DD_AGENT_MAJOR_VERSION=7
export DD_API_KEY=<your datadog API key here>
export DD_SITE=datadoghq.eu

#CONTAINER_NAME=ddhttpd
#CONTAINER_NAME=ddmysql
CONTAINER_NAME=ddcentos

docker run -d --privileged --name ${CONTAINER_NAME} \
               -v /var/run/docker.sock:/var/run/docker.sock:ro \
               -v ${PWD}/:/mnt/host \
               -e DD_AGENT_MAJOR_VERSION=${DD_AGENT_MAJOR_VERSION} \
               -e DD_API_KEY=${DD_API_KEY} \
               -e DD_SITE=${DD_SITE} \
               datadog-centos:1.0
```


## Install and enable the datadog agent
note: we can't do this when we build the image as the container needs to be running with the init entrypoint first before we start the agent with systemd.
```
docker exec -it ${CONTAINER_NAME} bash
/dd-agent-install_script.sh
systemctl enable datadog-agent
systemctl start datadog-agent
# ..install some software service and enable the datadog agent integration..
# systemctl restart datadog-agent
updatedb
exit
```
