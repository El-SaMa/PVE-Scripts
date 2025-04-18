#!/usr/bin/env bash

# Windmill.dev LXC Installer (tteck-style)
# Author: elsama + GPT sidekick 😎
# License: MIT

function header_info {
cat <<"EOF"
__        ___           _       _ _       
\ \      / (_)         | |     | | |      
 \ \ /\ / / _ _ __ ___ | | ___ | | | ___  
  \ V  V / | | '_ ` _ \| |/ _ \| | |/ _ \ 
   \_/\_/  |_| | | | | | | (_) | | | (_) |
             |_| |_| |_|\___/|_|_|\___/  
                                         
EOF
}
YW=$(echo "\033[33m")
GN=$(echo "\033[1;92m")
RD=$(echo "\033[01;31m")
CL=$(echo "\033[m")
CM="${GN}✓${CL}"
BFR="\\r\\033[K"
HOLD="-"
APP="Windmill.dev"
IP=$(hostname -I | awk '{print $1}')
hostname="$(hostname)"

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
shopt -s expand_aliases
alias die='EXIT=$? LINE=$LINENO error_exit'
trap die ERR

function error_exit() {
  trap - ERR
  local reason="Unknown failure occurred."
  local msg="${1:-$reason}"
  echo -e "${RD}‼ ERROR ${CL}$EXIT@$LINE $msg" 1>&2
  exit $EXIT
}

function msg_info() {
  echo -ne " ${HOLD} ${YW}${1}..."
}

function msg_ok() {
  echo -e "${BFR} ${CM} ${GN}${1}${CL}"
}

clear
header_info

if command -v pveversion >/dev/null 2>&1; then
  echo -e "⚠️  Can't run inside Proxmox host"
  exit
fi

while true; do
    read -rp "This will install ${APP} on ${hostname}. Proceed (y/n)? " yn
    case $yn in
        [Yy]*) break ;;
        [Nn]*) exit ;;
        *) echo "Please answer yes or no." ;;
    esac
done

msg_info "Updating system"
apt-get update &>/dev/null
msg_ok "System updated"

msg_info "Installing dependencies (Docker, Git)"
apt-get install -y curl git docker.io docker-compose &>/dev/null
msg_ok "Dependencies installed"

msg_info "Cloning Windmill repo"
git clone https://github.com/windmill-labs/windmill.git /opt/windmill &>/dev/null
msg_ok "Cloned Windmill"

cd /opt/windmill || exit 1
cp .env.sample .env

msg_info "Starting Windmill stack"
docker-compose up -d --build &>/dev/null
msg_ok "Windmill is now running"

echo -e "\n${APP} should now be accessible at: ${YW}http://${IP}:3000${CL}\n"
