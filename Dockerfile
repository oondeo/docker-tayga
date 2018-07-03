FROM debian
MAINTAINER jralfaro@oondeo.es

ENV \
	TAYGA_CONF_DATA_DIR=/var/spool/tayga \
	TAYGA_CONF_DIR=/etc \
	TAYGA_CONF_IPV4_ADDR=172.18.0.100 \
	TAYGA_CONF_PREFIX=2001:db8:64:ff9b::/96 \
	TAYGA_CONF_DYNAMIC_POOL=172.18.0.128/25 \
    TAYGA_CONF_IPV6_ADDR=2001:db8:64:ff9b::1 \
    PUBLIC_IF=eth0 \
    PRIVATE_IF=eth1

RUN apt-get update && apt-get install -y tayga iptables && apt-get clean

ADD docker-entry.sh /
RUN chmod +x /docker-entry.sh

ENTRYPOINT ["/docker-entry.sh"]
