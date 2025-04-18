#!/usr/bin/env bash

# Windmill.dev Proxmox LXC Installer
# Author: elsama
# Inspired by tteck
APP="Windmill.dev"
CTID=902
TEMPLATE="local:vztmpl/debian-12-standard_20240311_amd64.tar.zst"
HOSTNAME="windmill"
DISK_SIZE="8"
CPU="2"
RAM="2048"
BRIDGE="vmbr0"
UNPRIV="1"

echo -e "\033[1;92mCreating LXC container for $APP...\033[0m"

pct create $CTID $TEMPLATE \
  --rootfs local-lvm:${DISK_SIZE}G \
  --hostname $HOSTNAME \
  --net0 name=eth0,bridge=$BRIDGE,ip=dhcp \
  --cores $CPU \
  --memory $RAM \
  --unprivileged $UNPRIV \
  --features nesting=1,keyctl=1 \
  --start 1 \
  --onboot 1

echo -e "\033[1;92m✓ LXC $CTID created and started. Installing $APP...\033[0m"

pct exec $CTID -- bash -c "
  apt update &&
  apt install -y curl git docker.io docker-compose &&
  git clone https://github.com/windmill-labs/windmill.git /opt/windmill &&
  cd /opt/windmill &&
  cp .env.sample .env &&
  docker-compose up -d --build
"

echo -e "\n\033[1;92m✓ All done. Check Windmill at: http://<container-IP>:3000\033[0m"
