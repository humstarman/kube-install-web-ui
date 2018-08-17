#!/bin/bash
if [ -x "$(command -v netstat)" ]; then
  exit 0
fi
if [ -x "$(command -v apt-get)" ]; then
  apt-get update
  apt-get install -y net-tools 
fi
if [ -x "$(command -v yum)" ]; then
  yum makecache fast
  yum install -y net-tools 
fi
