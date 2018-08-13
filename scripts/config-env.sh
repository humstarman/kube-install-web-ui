#!/bin/bash
show_help () {
cat << USAGE
usage: $0 [ -e ENV-SETTING-FILE ] [ -n NODE-HOME ]
    -e : Specify the environment file.
    -n : Specify the value of NODE_HOME. 
    -t : Specify the temporary profile file to source. 
 
USAGE
exit 0
}
# Get Opts
while getopts "he:n:t:" opt; do # 选项后面的冒号表示该选项需要参数
    case "$opt" in
    h)  show_help
        ;;
    e)  ENV_FILE="$REVERSE_CIDRS $OPTARG" # 参数存在$OPTARG中
        ;;
    n)  NODE_HOME=$OPTARG
        ;;
    t)  PROFILE=$OPTARG
        ;;
    ?)  # 当有不认识的选项的时候arg为?
        echo "unkonw argument"
        exit 1
        ;;
    esac
done
[ -z "$*" ] && show_help
chk_var () {
if [ -z "$2" ]; then
  echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [ERROR] - no input for \"$1\", try \"$0 -h\"."
  sleep 3
  exit 1
fi
}
chk_var -e ${ENV_FILE}
chk_var -n ${NODE_HOME}
chk_var -t ${PROFILE}
[ -f $ENV_FILE ] || touch $ENV_FILE
[ -f $PROFILE ] || touch $PROFILE
cat >> ${PROFILE}<<"EOF"
#!/bin/bash
EOF
cat >> ${PROFILE}<<EOF
export NODE_HOME=${NODE_HOME}
EOF
cat >> ${PROFILE}<<"EOF"
export PATH=$NODE_HOME/bin:$PATH
EOF
chmod +x ${PROFILE}
if cat ${ENV_FILE} | grep "export NODE_HOME=" >/dev/null 2>&1; then
  TMP=$(echo ${NODE_HOME} | tr "/" "?")
  #echo $TMP
  N=$(cat ${ENV_FILE} | grep -n "export NODE_HOME=")
  N=${N%%:*}
  #echo $N
  sed -i "${N}c export NODE_HOME=${TMP}" ${ENV_FILE}
  sed -i s^"?"^"/"^g ${ENV_FILE}
  source ${ENV_FILE}
  exit 0
fi
cat >> ${ENV_FILE}<<EOF
export NODE_HOME=${NODE_HOME}
EOF
cat >> ${ENV_FILE}<<"EOF"
export PATH=$NODE_HOME/bin:$PATH
EOF
source ${ENV_FILE}
