#!/bin/bash
# Script Name: 	setup_requirements.sh
# Description: 	This script installs
# the necessary requirements for
# Freifunk Gluon on an Ubuntu or Debian 
# system.
# Author:	Siegfried K.
# Version: 	1.0
# Date:		2023-08-05 - 11:06 pm

if [ "$(id -u)" != "0" ]
then
	echo "This script requires root privileges" 1>&2
	exit 1
else
	apt update && \ 
	apt install git \
		subversion \
		python3 \
		build-essential \
		gawk \
		unzip \
		libncurses5-dev \
		zlib1g-dev \
		libssl-dev \
		wget \
		time \
		qemu-utils
fi
