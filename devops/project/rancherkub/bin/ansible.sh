#!/bin/bash

#########################################
#					#
# Script: ansible.sh                    #
# input: N/A                            #
# output: (Ansible output)              #
#					#
# Author: Guilherme Lucca               #
#					#
# Release                               #
# -------------------------------       #
# 1.0 | 2020-11-19 : Initial release    #
# 2.0 | 2020-12-02 : DIRs changed       #
#					#
#########################################

# Variables

LIGHTBLUE='\033[1;34m'
NC='\033[0m' # No color

SCRIPT_DIR=${HOME}/devops/project/rancherkub

CONFIG_DIR=${SCRIPT_DIR}/cfg
BIN_DIR=${SCRIPT_DIR}/bin

# RUN ANSIBLE PLAYBOOK

cd ${BIN_DIR}
cp -f ${CONFIG_DIR}/hosts_init hosts

echo -e "\n${LIGHTBLUE}> RUN ANSIBLE PLAYBOOK${NC}"
ansible-playbook -i hosts -b ${BIN_DIR}/playbook.yml
