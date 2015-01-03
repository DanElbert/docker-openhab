docker run -d -p 6300:8080 --device=/dev/ttyUSB0:/dev/ttyZwave0 -v /etc/openhab/configurations:/opt/openhab/configurations danelbert/docker-openhab
