#!/bin/bash

wget --quiet --no-check-certificate --no-cookies -O /tmp/habmin.zip https://github.com/cdjackson/HABmin/releases/download/0.1.3-snapshot/habmin.zip

mkdir -p /opt/habmin

unzip -q -d /opt/habmin /tmp/habmin.zip

cp /opt/habmin/addons/org.openhab.io.habmin-1.5.0-SNAPSHOT.jar /opt/openhab/addons-available/
cp -r /opt/habmin/webapps/habmin /opt/openhab/webapps
