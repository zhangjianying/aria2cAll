#!/usr/bin/bash

# 工作目录
work_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# 检查是否安装node
checkNode(){
   if ! type node >/dev/null 2>&1; then
      # echo 'node 未安装';
      return 1
   else
      # echo 'node 已安装';
      return 0
   fi
}

# 检查是否安装npm
checkNpm(){
   if ! type npm >/dev/null 2>&1; then
      # echo 'node 未安装';
      return 1
   else
      # echo 'node 已安装';
      return 0
   fi
}


# 检查是否下载node依赖
install()
{
   checkNode
   checkNodeResult=$?

   if [ $checkNodeResult == 1 ]; then
      echo "请先安装node环境再运行，当前应用已退出"
      exit 1;
   fi

   checkNpm
   checkNpmResult=$?

   if [ $checkNpmResult == 1 ]; then
      echo "请先安装npm环境再运行，当前应用已退出"
      exit 1;
   fi
   
   if [ ! -d "$work_dir/node_modules" ]; then
      echo "正在下载依赖库"
      npm install
   fi
}

# 删除依赖库
uninstall()
{
   rm -fR node_modules
}

# 重启aria2c服务
_restartAria2c()
{
   _stopAria2c
   cd $work_dir
   nohup $work_dir/aria2c --conf-path=$work_dir/aria2.conf >> /dev/shm/aria2c.log 2>&1 &
}

# 启动web服务
_restartWebServer()
{
   _stopWebServer
   cd $work_dir
   nohup $work_dir/node_modules/http-server/bin/http-server -a 0.0.0.0 -p 6900 >> /dev/shm/httpserver.log 2>&1 &
}


_stopWebServer()
{
   cd $work_dir
   pid=$(ps -ef|grep http-server|grep -v grep |awk '{printf $2}')
   if [[ -n "$pid" ]];  then
      kill -9 $pid
   fi
}

_stopAria2c()
{
   cd $work_dir
   pid=$(ps -ef|grep $work_dir/aria2c|grep -v grep |awk '{printf $2}')
   if [[ -n "$pid" ]];  then
      kill -9 $pid
   fi
}

# 停止服务
stop(){
   _stopAria2c
   _stopWebServer
}


# 启动服务
start()
{
   install
   _restartAria2c
   _restartWebServer
   echo "open localhost:6900 "
}

restart()
{
   install
   _restartAria2c
   _restartWebServer

   echo "open localhost:6900 "
}


# 更新Tracker
updataTracker()
{
list=`wget --no-check-certificate -qO- https://www.yaozuopan.top/dynamic/trackerlist.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
if [ -z "`grep "bt-tracker" $work_dir/aria2.conf`" ]; then
    sed -i '$a bt-tracker='${list} $work_dir/aria2.conf
    echo add......
else
    sed -i "s@bt-tracker.*@bt-tracker=$list@g" $work_dir/aria2.conf
    echo update......
fi

}

case $1 in
    'install')
       install
    ;;
    'uninstall')
       uninstall
    ;;
    'start')
       start
    ;;
    'stop')
       stop
    ;;
    'restart')
        restart
    ;;
    'updata')
        updataTracker
    ;;
    *)
    echo "Usage: $0 {install | uninstall | start | stop | restart}"
    exit 2
    ;;
esac