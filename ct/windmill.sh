#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 El-SaMa
# Author: El-SaMa | https://github.com/El-SaMa
# License: MIT
# Source: https://windmill.dev/

APP="Windmill"
var_tags="workflow;automation;ai"
var_cpu="2"
var_ram="2048"
var_disk="8"
var_os="debian"
var_version="12"
var_unprivileged="1"

header_info "$APP"
variables
color
catch_errors

function run_script_in_container() {
  # Push and execute windmill installer inside the container
  lxc-attach -n "$CTID" -- bash -c "bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/El-SaMa/PVE-Scripts/main/install/windmill-install.sh)\""
}

start
build_container
description
run_script_in_container

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:3000${CL}"
