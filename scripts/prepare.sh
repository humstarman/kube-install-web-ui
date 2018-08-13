#!/bin/bash
if [ -x "$(command -v apt-get)" ]; then
  apt-get update
  apt-get install -y cmake 
fi
if [ -x "$(command -v yum)" ]; then
  yum makecache fast
  yum install -y cmake
fi
