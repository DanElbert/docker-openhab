docker run --name="openhab1.6.2" -d -p 6300:8080 --device=/dev/ttyUSB0:/dev/ttyZwave0 -v /etc/openhab/configurations:/opt/openhab/configurations -v /var/log/openhab:/opt/openhab/logs danelbert/docker-openhab
