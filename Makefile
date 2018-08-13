SHELL=/bin/bash
VER=v8.11.3
ENV_FILE=/etc/profile
NODE_HOME=/usr/local/node
NODE_BIN=${NODE_HOME}/bin
URL=https://nodejs.org/download/release/${VER}/node-${VER}-linux-x64.tar.gz

all: download unzip mv config test install-express

download:
	@[ -f node-${VER}-linux-x64.tar.gz ] || curl -O ${URL} 

unzip:
	@[ -d node-${VER}-linux-x64 ] || tar -zxvf node-${VER}-linux-x64.tar.gz

prepare:
	@./scripts/prepare.sh

install:
	@cd node-${VER} && ./configure --prefix=${NODE_HOME} && make && make install

mv:
	@[ -d ${NODE_HOME} ] || mv node-${VER}-linux-x64 ${NODE_HOME}

source:
	@export NODE_NAME=${NODE_HOME}
	@export PATH=${NODE_HOME}/bin:${PATH}

config:
	@./scripts/config-env.sh -e ${ENV_FILE} -n ${NODE_HOME}

test:
	@env PATH=${NODE_BIN}:$(PATH) node -v

install-express:
	@env PATH=${NODE_BIN}:$(PATH) npm install -g express-generator
