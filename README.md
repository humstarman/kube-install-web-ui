# Kubernetes Installation Web UI

This project is powered by node.js.  

[TOC]

## Download

On a master to be, download this project:
```
wget https://github.com/humstarman/kube-install-web-ui/archive/master.zip
```
then, unzip.

## Install

Enter the folder of the project, run:
```
make
```
or:
```
make install
```
> Note: during the installation. firewall would be shudown.

## Visit

By default, the service uses port 3000.  

## Clean

Remove the installation of the web and stop the service, run:
```
make clean
```
> Note: this operation will not clean the installed Kubernetes cluster.
