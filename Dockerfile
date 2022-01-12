#----------------------#
# setup unicast-vxlan  #
#----------------------#

FROM crpd:latest

# daemonize package
RUN mkdir -p /etc/runit/unicast-vxlan/
ADD ./sc-vxlan/package/run-unicast-vxlan /etc/runit/unicast-vxlan/run
RUN chmod +x /etc/runit/unicast-vxlan/run 
RUN ln -s /etc/runit/unicast-vxlan/ /etc/service/unicast-vxlan

# daemonize mosquitto
RUN mkdir /etc/service/mosquitto
ADD ./sc-vxlan/package/mosquitto_run /etc/service/mosquitto/run
RUN chmod +x /etc/service/mosquitto/run

#Daemonize uipubd
RUN mkdir /etc/service/uipubd
ADD ./sc-vxlan/package/uipubd_run /etc/service/uipubd/run
RUN chmod +x /etc/service/uipubd/run

# Install required packages 
RUN apt-get update && apt-get install -y mosquitto \
    mosquitto-clients
RUN pip3 install paho-mqtt pyroute2

# Copy packages
RUN mkdir -p /var/opt/unicast-vxlan
RUN chmod -R 777 /var/opt/unicast-vxlan
ADD ./sc-vxlan/package/mosquitto.conf /etc/mosquitto/mosquitto.conf
ADD ./sc-vxlan/package/unicast-vxlan.py /var/opt/unicast-vxlan/ 
ADD ./sc-vxlan/package/basic-crpd-config /var/opt/unicast-vxlan/
ADD ./sc-vxlan/package/load-config.sh /var/opt/unicast-vxlan/
ADD ./sc-vxlan/package/unicast-vxlan.yang /var/opt/unicast-vxlan/
RUN chmod +x /var/opt/unicast-vxlan/unicast-vxlan.py 
CMD ["/sbin/runit-init.sh"]

# load yang package
RUN /usr/libexec/ui/yang-pkg add -i vxlan -m /var/opt/unicast-vxlan/unicast-vxlan.yang
