#!/bin/sh

# Create Tayga directories.
mkdir -p ${TAYGA_CONF_DATA_DIR} ${TAYGA_CONF_DIR}

# Configure Tayga
cat >${TAYGA_CONF_DIR}/tayga.conf <<EOF
tun-device nat64
ipv4-addr ${TAYGA_CONF_IPV4_ADDR}
prefix ${TAYGA_CONF_PREFIX}
dynamic-pool ${TAYGA_CONF_DYNAMIC_POOL}
data-dir ${TAYGA_CONF_DATA_DIR}
EOF

# Setup Tayga networking
tayga -c ${TAYGA_CONF_DIR}/tayga.conf --mktun
ip link set nat64 up
ip addr add ${TAYGA_CONF_IPV4_ADDR} dev nat64
ip addr add ${TAYGA_CONF_IPV6_ADDR} dev nat64
ip route add ${TAYGA_CONF_DYNAMIC_POOL} dev nat64
ip route add ${TAYGA_CONF_PREFIX} dev nat64
iptables -t nat -A POSTROUTING -o ${PUBLIC_IF} -j MASQUERADE
iptables -A FORWARD -i ${PUBLIC_IF} -o nat64 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i nat64 -o ${PUBLIC_IF} -j ACCEPT
iptables -A FORWARD -i ${PUBLIC_IF} -o nat64 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i nat64 -o ${PUBLIC_IF} -j ACCEPT

# Run Tayga
tayga -c ${TAYGA_CONF_DIR}/tayga.conf -d
