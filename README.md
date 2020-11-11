# aria2c+ariaNG 懒人版

为ubuntu 等64位系统做的懒人版本



## 特点

* aria2c  最新静态单文件版(v1.35)，https://github.com/q3aql/aria2-static-builds （可以根据自己的需要进行替换）
* ariaNG 单文件版(v1.1.7)，https://github.com/mayswind/AriaNgs
* 增加一键更新BTTracker,解决默认设置下 BT无速度的问题



可以满速下载magnet(磁力链接)

![截图录屏_选择区域_20201111130532](/home/coolzlay/mywork/workspace/test/aria2All/readme.assets/截图录屏_选择区域_20201111130532.png)



## 使用

chmod +x run.sh

run.sh {install | uninstall | start | stop | restart | updata}



updata -- 更新BTTracker

start -- 启动。 之后可以通过浏览器打开localhost:6900进行下载设置



如果不愿意每次重启都手动重启服务。可以考虑做成系统服务开机自动启动



## 其他

如果需要在chrome等浏览器集成下载能力。可以使用

https://github.com/jae-jae/Camtd/releases 

来完成