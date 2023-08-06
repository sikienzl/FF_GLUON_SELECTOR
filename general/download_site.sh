#!/bin/bash

########################################################
# Script Name: download_site.sh                       ##
# Description: This script allows you to select a     ##
#              Gluon site from a CSV file, download   ##
#              it from the repository, and            ##
#              install it in the chosen gluon path.   ##
# Author:      Siegfried K.                           ##
# Version:     1.0                                    ##
# Date:        2023-08-06 - 01:32 pm                  ##
########################################################

INSTALL_PATH=""
SELECTED_REPOSITORY_URL=""
DEFAULT_SITE_FOLDER="site"
SITE_FOLDERNAME=""
CURRENT_PATH=$(pwd)

define_install_path() {
    if [ -f .install_path.tmp ]; then
        echo "File exists"
        INSTALL_PATH=$(cat .install_path.tmp)
    else
        INSTALL_PATH=$(dialog --backtitle "Gluon Path" \
    --inputbox "Please enter the path where Gluon is installed" 0 0 2>&1 >/dev/tty)

        if [ $? -neq 0 ]; then
            echo "Dialog was cancelled. Exiting."
            exit 0
        fi
    fi
}

select_site() {
    sitename_array=()

    while IFS=',' read -r sitename repository_url; do
        if [ "$sitename" != "sitename" ]; then
            sitename_array+=("$sitename" "$repository_url")
        fi
    done < site.csv

    selected_value=$(dialog --backtitle "Gluon Site Selection" \
    --menu "Select a Gluon Site:" 0 0 0 \
    "${sitename_array[@]}" 2>&1 >/dev/tty)

    if [ $? -eq 0 ]; then
        for i in "${!sitename_array[@]}"; do
            if (( i == 0 )) || (( i % 2 == 0 )); then
                if [ "${sitename_array[$i]}" == "$selected_value" ]; then
                    SELECTED_REPOSITORY_URL="${sitename_array[$((i + 1))]}"
                    break
                fi
            fi
        done
    else
        echo "Dialog was canceled."
        return 1
    fi
}

get_site_foldername() {
    if [ -z "$SELECTED_REPOSITORY_URL" ]
    then
        echo "No site selected. Exiting."
        exit 0
    fi

    SITE_FOLDERNAME=$(basename "$SELECTED_REPOSITORY_URL" | sed 's/\.git//g')
}

download_site() {
    if [ -z "$SELECTED_REPOSITORY_URL" ]
    then
        echo "No site selected. Exiting."
        exit 0
    fi

    if [ -d "$INSTALL_PATH/$SITE_FOLDERNAME" ]
    then
        echo "Site already exists. Remove $INSTALL_PATH/$SITE_FOLDERNAME to download again."
        rm -rf "$INSTALL_PATH/$SITE_FOLDERNAME"
    fi

    cd "$INSTALL_PATH" 
    git clone $SELECTED_REPOSITORY_URL
    cd "$CURRENT_PATH"
}

create_link() {
    if [ -z "$SITE_FOLDERNAME" ]
    then
        echo "No site selected. Exiting."
        exit 0
    fi

    ln -s "$INSTALL_PATH/$SITE_FOLDERNAME" "$INSTALL_PATH/$DEFAULT_SITE_FOLDER"
}

cleanup() {
    if [ -f .install_path.tmp ]; then
        echo "Cleaning up..."
        rm -f .install_path.tmp
    fi
}

define_install_path
select_site
get_site_foldername
download_site
create_link
cleanup