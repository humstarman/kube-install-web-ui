VER=v8.11.3
ENV_FILE=/etc/profile
NODE_HOME=/usr/local/node
NODE_BIN=/usr/local/node/bin
URL=https://nodejs.org/download/release/${VER}/node-${VER}-linux-x64.tar.gz
TMP_PROFILE=/tmp/source-profile.sh

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
	@[ -d ${NODE_HOME} ] || mv node-${VER}-linux-x64 ${NODE_HOME}

config:
	@./scripts/config-env.sh -e ${ENV_FILE} -n ${NODE_HOME} -t ${TMP_PROFILE}
	@${TMP_PROFILE}

test:
	@${NODE_BIN}/node -v

install-express:
	@${NODE_BIN}/npm install -g express-generator
