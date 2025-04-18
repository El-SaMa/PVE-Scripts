#!/usr/bin/env bash

# Windmill.dev LXC Installer (tteck-style, minimal)
# Author: elsama
# License: MIT

APP="Windmill.dev"
CTID=902
HOSTNAME="windmill"
DISK_SIZE="8"
CORE_COUNT="2"
RAM_SIZE="2048"
BRIDGE="vmbr0"
IP="dhcp"
GATEWAY=""
UNPRIVILEGED=1

echo -e "\n\033[1;92mInstalling container for $APP...\033[0m"

# Create container
pct create $CTID local:vztmpl/debian-12-standard_*.tar.zst \
  --rootfs local-lvm:${DISK_SIZE} \
  --hostname $HOSTNAME \
  --net0 name=eth0,bridge=$BRIDGE,ip=$IP \
  --cores $CORE_COUNT \
  --memory $RAM_SIZE \
  --unprivileged $UNPRIVILEGED \
  --features nesting=1,keyctl=1 \
  --start 1 \
  --onboot 1

echo -e "\033[1;92m✓ Container created with ID $CTID\033[0m"

# Attach and install Windmill
pct exec $CTID -- bash -c "
  apt-get update -qq &&
  apt-get install -y curl git docker.io docker-compose -qq &&
  git clone https://github.com/windmill-labs/windmill.git /opt/windmill &&
  cd /opt/windmill &&
  cp .env.sample .env &&
  docker-compose up -d --build
"

echo -e "\n\033[1;92m✓ Windmill should now be running at: http://<container-IP>:3000\033[0m"
