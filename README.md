# FREIFUNK Gluon Selector
This repository contains a collection of scripts designed to simplify the selection and building of Gluon for the respective Freifunk groups.

## Prerequisites
To execute these scripts, you will need the `dialog` package. For Debian-based distributions, 
you can type the following command:
```bash
$ apt update && apt install dialog
```

## Run
To build Gluon, you will need some packages. 
To install them, you can use the setup script:
```bash
$ ./distribution/<DISTRONAME>/setup_requirements.sh
```

Once the required packages are installed, you can use the following 
scripts to obtain the sources:
```bash
$ cd general
$ ./download_gluon.sh
$ ./download_site.sh
```
