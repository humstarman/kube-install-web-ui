SHELL=/bin/bash
VER=v8.11.3
ENV_FILE=/etc/profile
NODE_HOME=/usr/local/node
NODE_BIN=${NODE_HOME}/bin
URL=https://nodejs.org/download/release/${VER}/node-${VER}-linux-x64.tar.gz
PORT=3000

all: download unzip mv config chk install-express deploy echo

download:export FILE=node-${VER}-linux-x64.tar.gz 
download:
	@if [ -f /tmp/${FILE} ]; then yes | cp /tmp/${FILE} ./; fi
	@[ -f ${FILE} ] || curl -O ${URL} 

unzip:
	@[ -d node-${VER}-linux-x64 ] || tar -zxf node-${VER}-linux-x64.tar.gz

prepare:
	@./scripts/prepare.sh

cp:
	@find ./manifests -type f -name "*.sed" | sed s?".sed"?""?g | xargs -I {} cp {}.sed {}

sed:
	@sed -i s?"{{.port}}"?"${PORT}"?g ./manifests/bin/www

install: all

compile:
	@cd node-${VER} && ./configure --prefix=${NODE_HOME} && make && make install

mv:
	@[ -d ${NODE_HOME} ] || mv node-${VER}-linux-x64 ${NODE_HOME}

source:
	@export NODE_NAME=${NODE_HOME}
	@export PATH=${NODE_HOME}/bin:${PATH}

config:
	@./scripts/config-env.sh -e ${ENV_FILE} -n ${NODE_HOME}

chk:
	@env PATH=${NODE_BIN}:$(PATH) node -v

install-express:
	@env PATH=${NODE_BIN}:$(PATH) npm install -g express-generator

deploy: cp sed
	@./scripts/stop-firewall.sh
	@cd ./manifests && env PATH=${NODE_BIN}:$(PATH) npm install
	@cd ./manifests && env PATH=${NODE_BIN}:$(PATH) nohup npm start & 

echo:
	@echo "=========="
	@echo "Visiting http://127.0.0.1:${PORT} on your browser to start installing Kubernetes."
	@echo "=========="

stop:
	@./scripts/chk-netstat.sh
	@./scripts/stop-node.sh -p ${PORT}

clean: stop uninstall

uninstall:
	@cd ./manifests && env PATH=${NODE_BIN}:$(PATH) npm uninstall

test:
	@curl http://127.0.0.1:${PORT}
