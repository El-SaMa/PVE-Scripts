#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
APP="Windmill.dev"
var_tags="devops;automation;orchestration"
var_cpu="4"
var_ram="2048"
var_disk="8"
var_os="debian"
var_version="12"
var_unprivileged="1"

header_info "$APP"
variables
color
catch_errors

function install_script() {
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/El-SaMa/PVE-Scripts/main/install/windmill-install.sh)"
}

start
build_container
description
msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Attach to the container with:${CL}"
echo -e "${TAB}${BL}lxc-attach -n ${CTID}${CL}"
echo -e "${INFO}${YW} Then run the install script manually if needed:${CL}"
echo -e "${TAB}${BL}install_script${CL}"
