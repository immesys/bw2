FROM ubuntu:xenial
MAINTAINER Michael Andersen

RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y libssl-dev iptables byobu net-tools iproute2
ADD bw2 /usr/bin/bw2
RUN chmod a+x /usr/bin/bw2
ADD entrypoint.sh /
ADD bw_config.json /var/
RUN chmod a+x /entrypoint.sh
LABEL io.cadvisor.metric.prometheus-bw="/var/metrics.json"
ENTRYPOINT /entrypoint.sh
