#!/bin/bash

tags_array=($(git ls-remote --tags https://github.com/freifunk-gluon/gluon.git | awk -F/ '{ print $3}' | grep -v '\^{}'))

for tag in "${tags_array[@]}"; do
	echo "$tag"
done
