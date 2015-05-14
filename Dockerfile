
# Openhab 1.6.2
# * configuration is injected
#
FROM ubuntu:14.04
MAINTAINER Tom Deckers <tom@ducbase.com>

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install unzip supervisor wget curl

# Download and install Oracle JDK
# For direct download see: http://stackoverflow.com/questions/10268583/how-to-automate-download-and-installation-of-java-jdk-on-linux
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O /tmp/jdk-8u45-linux-x64.tar.gz http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz
RUN tar -zxC /opt -f /tmp/jdk-8u45-linux-x64.tar.gz
RUN ln -s /opt/jdk1.8.0_45 /opt/jdk8

# Download Openhab 1.6.2
ADD https://github.com/openhab/openhab/releases/download/v1.6.2/distribution-1.6.2-runtime.zip /tmp/distribution-1.6.2-runtime.zip
ADD https://github.com/openhab/openhab/releases/download/v1.6.2/distribution-1.6.2-addons.zip /tmp/distribution-1.6.2-addons.zip

RUN mkdir -p /opt/openhab/addons-avail
RUN unzip -d /opt/openhab /tmp/distribution-1.6.2-runtime.zip
RUN unzip -d /opt/openhab/addons-avail /tmp/distribution-1.6.2-addons.zip
RUN chmod +x /opt/openhab/start.sh
RUN mkdir -p /opt/openhab/logs

ADD http://downloads.sourceforge.net/project/sigar/sigar/1.6/hyperic-sigar-1.6.4.tar.gz /tmp/hyperic-sigar-1.6.4.tar.gz
RUN mkdir -p /opt/openhab/lib
RUN tar -zxf /tmp/hyperic-sigar-1.6.4.tar.gz --wildcards --strip-components=2 -C /opt/openhab hyperic-sigar-1.6.4/sigar-bin/lib/*

# Add myopenhab 1.4.0 which works fine for openhab 1.6.1 (?)
# ADD https://my.openhab.org/downloads/org.openhab.io.myopenhab-1.4.0-SNAPSHOT.jar /opt/openhab/addons-avail/org.openhab.io.myopenhab-1.4.0-SNAPSHOT.jar

# Add habmin
ADD https://github.com/cdjackson/HABmin/releases/download/0.1.3-snapshot/habmin.zip /opt/habmin/habmin-0.1.3.zip
RUN cd /opt/habmin && unzip /opt/habmin/habmin-0.1.3.zip
RUN cp /opt/habmin/addons/org.openhab.io.habmin-1.5.0-SNAPSHOT.jar /opt/openhab/addons-avail/
RUN cp -r /opt/habmin/webapps/habmin /opt/openhab/webapps

# External configs
RUN mkdir -p /opt/openhab/external_configurations

# Add greent
ADD https://github.com/openhab/openhab/releases/download/v1.6.2/distribution-1.6.2-greent.zip /opt/greent/greent-1.6.2.zip
RUN cd /opt/greent && unzip /opt/greent/greent-1.6.2.zip
RUN cp -r /opt/greent/greent /opt/openhab/webapps

# Add startcom ca
ADD files/ca.pem /opt/ca.pem
RUN /opt/jdk8/bin/keytool -import -file /opt/ca.pem -alias startcom -keystore /opt/jdk8/jre/lib/security/cacerts -storepass changeit -noprompt

# Add pipework to wait for network if needed
ADD files/pipework /usr/local/bin/pipework
RUN chmod +x /usr/local/bin/pipework

# Configure supervisor to run openhab
ADD files/supervisord.conf /etc/supervisor/supervisord.conf
ADD files/openhab.conf /etc/supervisor/conf.d/openhab.conf
ADD files/boot.sh /usr/local/bin/boot.sh
RUN chmod +x /usr/local/bin/boot.sh

# Restart openhab on network up.  Needed when starting with --net="none" to add network later.
ADD files/openhab-restart /etc/network/if-up.d/openhab-restart
RUN chmod +x /etc/network/if-up.d/openhab-restart

# Clean up
RUN rm -rf /tmp/*

EXPOSE 8080 8443 5555 9001

CMD ["/usr/local/bin/boot.sh"]
