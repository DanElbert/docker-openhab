# Openhab 1.8.3
# * configuration is injected
#
FROM ubuntu:16.04
MAINTAINER Dan Elbert

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install unzip supervisor wget less

# Download and install Oracle JDK
# For direct download see: http://stackoverflow.com/questions/10268583/how-to-automate-download-and-installation-of-java-jdk-on-linux
RUN wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O /tmp/jdk-8u91-linux-x64.tar.gz http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.tar.gz
RUN tar -zxC /opt -f /tmp/jdk-8u91-linux-x64.tar.gz
RUN ln -s /opt/jdk1.8.0_91 /opt/jdk8

ENV OPENHAB_VERSION 1.8.3

ADD files /root/docker-files/

RUN \
  chmod +x /root/docker-files/scripts/download_openhab.sh  && \
  chmod +x /root/docker-files/scripts/download_habmin.sh  && \
  cp /root/docker-files/supervisord.conf /etc/supervisor/supervisord.conf && \
  cp /root/docker-files/openhab.conf /etc/supervisor/conf.d/openhab.conf && \
  cp /root/docker-files/boot.sh /usr/local/bin/boot.sh && \
  mkdir -p /opt/openhab/logs && \
  chmod +x /usr/local/bin/boot.sh && \
  rm -rf /tmp/*

#
# Download openHAB based on Environment OPENHAB_VERSION
#
RUN /root/docker-files/scripts/download_openhab.sh

RUN /root/docker-files/scripts/download_habmin.sh

EXPOSE 8080

CMD ["/usr/local/bin/boot.sh"]
