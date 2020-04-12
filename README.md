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

## Example running Tomcat and datadog agent with tomcat monitoring enabled
```
[root@ddagent-centos1 /]# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 Apr09 ?        00:00:04 /usr/sbin/init
root        17     1  0 Apr09 ?        00:01:52 /usr/lib/systemd/systemd-journald
root        18     1  0 Apr09 ?        00:00:00 /usr/sbin/crond -n
root       128     1  0 Apr09 ?        00:00:59 /usr/sbin/rsyslogd -n
dbus       515     1  0 Apr09 ?        00:00:02 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation
tomcat    2080     1  0 Apr09 ?        00:04:06 /usr/lib/jvm/jre/bin/java -classpath /usr/share/tomcat/bin/bootstrap.jar:/usr/share/tomcat/bin/tomcat-j
dd-agent  2430     1  0 Apr09 ?        00:24:39 /opt/datadog-agent/bin/agent/agent run -p /opt/datadog-agent/run/agent.pid
dd-agent  2431     1  0 Apr09 ?        00:01:15 /opt/datadog-agent/embedded/bin/process-agent --config=/etc/datadog-agent/datadog.yaml --sysprobe-confi
dd-agent  2432     1  0 Apr09 ?        00:03:24 /opt/datadog-agent/embedded/bin/trace-agent --config /etc/datadog-agent/datadog.yaml --pid /opt/datadog
dd-agent  2503  2430  0 Apr09 ?        00:06:04 java -Xmx200m -Xms50m -classpath /opt/datadog-agent/bin/agent/dist/jmx/jmxfetch.jar org.datadog.jmxfetc
root      2753     1  0 Apr09 ?        00:00:01 /usr/lib/systemd/systemd-logind
root     24033     0  0 19:00 pts/0    00:00:00 bash
root     24095 24033  0 19:01 pts/0    00:00:00 ps -ef
```
