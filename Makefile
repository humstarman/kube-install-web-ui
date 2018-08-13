VER=v8.11.3
ENV_FILE=/etc/profile
NODE_HOME=/usr/local/node
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
	@node -v

install-express:
	@npm install -g express-generator
