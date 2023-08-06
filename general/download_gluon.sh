#!/bin/bash

########################################################
# Script Name: download_gluon.sh                      ##
# Description: This script downloads Gluon from the   ##
#              official repository in the selected    ##
#              version and installs it in the chosen  ##
#              path.                                  ##
# Author:      Siegfried K.                           ##
# Version:     1.0                                    ##
# Date:        2023-08-06 - 10:13 am                  ##
########################################################

RELEASE_TAG=""
INSTALL_PATH=""
GLUON_REPO="https://github.com/freifunk-gluon/gluon.git"

download_gluon() {
	git clone "$GLUON_REPO" "$INSTALL_PATH" -b "$RELEASE_TAG"
}

define_install_path() {
	INSTALL_PATH=$(dialog --backtitle "Gluon Release Selection" \
	--inputbox "Please enter the path where Gluon should be installed" 0 0 2>&1 >/dev/tty)

	if [ $? -eq 0 ]
	then
		if [ -z "$INSTALL_PATH" ] 
		then
			INSTALL_PATH="/home/$USER"
		fi
	else
		echo "Dialog was cancelled. Exiting."
		exit 0
	fi

	INSTALL_PATH="$INSTALL_PATH/gluon"
    echo "$INSTALL_PATH" >> .install_path.tmp
	
}

select_release_value() {
counter=1
    tags_array=($(git ls-remote --tags https://github.com/freifunk-gluon/gluon.git | awk -F/ '{ print $3}' | grep -v '\^{}'))
    tags_list=""

    for tag in "${tags_array[@]}"; do
        tags_list="$tags_list $counter \"$tag\" off "
        counter=$((counter+1))
    done

    selected_index=$(dialog --backtitle "Gluon Release Selection" \
    --radiolist "Select the Gluon Release you want to build" 0 0 $counter \
    $tags_list 2>&1 >/dev/tty)

    if [ $? -eq 0 ]; then
        if [ "$selected_index" -gt 0 ] && [ "$selected_index" -le ${#tags_array[@]} ]; then
            selected_tag="${tags_array[$((selected_index-1))]}"
            RELEASE_TAG="$selected_tag"
            
        else
            echo "No valid index selected. Exiting."
			exit 1
        fi
    else
        echo "Dialog was cancelled. Exiting."
		exit 0
    fi
}

select_release_value
define_install_path
download_gluon