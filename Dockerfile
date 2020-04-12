FROM centos/systemd

RUN echo alias l=\'ls -latFrh\' >> /root/.bashrc
RUN mkdir /mnt/host

RUN yum -y install mlocate; yum clean all

RUN curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh -o /dd-agent-install_script.sh ; chmod +x /dd-agent-install_script.sh

CMD ["/usr/sbin/init"]
