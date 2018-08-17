#!/bin/bash
DEFAULT_STATUS="LISTEN"
show_help () {
cat << USAGE
usage: $0 [ -p PORT ] [ -s STATUS ]
    -p : Specify the port used by the service. 
    -s : Specify the working status of the service. 
         If not specified, use "${DEFAULT_STATUS}" by default.
USAGE
exit 0
}
# Get Opts
while getopts "hp:s:" opt; do # 选项后面的冒号表示该选项需要参数
    case "$opt" in
    h)  show_help
        ;;
    p)  PORT=$OPTARG
        ;;
    s)  STATUS=$OPTARG
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
chk_var -p $PORT
STATUS=${STATUS:-"${DEFAULT_STATUS}"}
PID=$(netstat -antlp | grep :${PORT} | grep ${STATUS} | awk -F ' ' '{print $7}')
PID=${PID%%/*}
kill -9 $PID
