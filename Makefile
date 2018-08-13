VER=v8.11.3
ENV_FILE=/etc/profile
NODE_HOME=/usr/local/node

all: download unzip install config test install-express

download:
	@[ -f node-${VER}.tar.gz ] || curl -O https://nodejs.org/dist/${VER}/node-${VER}.tar.gz

unzip:
	@[ -d node-${VER} ] || tar -zxvf node-${VER}.tar.gz

prepare:
	@./scripts/prepare.sh

install:
	@cd node-${VER} && ./configure --prefix=${NODE_HOME} && make && make install

config:
	@./scripts/config-env.sh -e ${ENV_FILE} -n ${NODE_HOME}
	@source ${ENV_FILE}

test:
	@node -v

install-express:
	@npm install -g express-generator
