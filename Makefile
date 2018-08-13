VER=v8.11.3
ENV_FILE=/etc/profile
NODE_HOME=/usr/local/node
URL=https://nodejs.org/download/release/${VER}/node-${VER}-linux-x64.tar.gz

all: download unzip prepare mv config test install-express

download:
	@[ -f node-${VER}-linux-x64.tar.gz ] || curl -O ${URL} 

unzip:
	@[ -d node-${VER}-linux-x64 ] || tar -zxvf node-${VER}-linux-x64.tar.gz

prepare:
	@./scripts/prepare.sh

install:
	@cd node-${VER} && ./configure --prefix=${NODE_HOME} && make && make install

mv:
	@mv node-${VER}-linux-x64 ${NODE_HOME}

config:
	@./scripts/config-env.sh -e ${ENV_FILE} -n ${NODE_HOME}
	@source ${ENV_FILE}

test:
	@node -v

install-express:
	@npm install -g express-generator
