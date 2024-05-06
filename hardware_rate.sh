#!/bin/bash
#create_by: 邓家豪   create_time: 2023-08-22    update_time: 2023-08-22    version: v1.0

#声明cpu监控函数
function cpu(){

 #使用awk收集vmstat命令13列和14列的值，当前用户占用的资源us和系统占用的资源sy
 util=$(vmstat | awk '{if(NR==3) print $13+$14}')

 #收集等待IO所消耗的CPU时间
 iowait=$(vmstat | awk '{if(NR==3) print $16}')

 #输出CPU使用率和IO使用率
 echo "CPU -使用率：${util}% ,等待磁盘IO相应使用率：${iowait}:${iowait}%"
 
}

#声明内存监控函数
function memory(){
 #使用awk统计内存的总大小（转换单位G）
 total=`free -m |awk '{if(NR==2)printf "%.1f",$2/1024}'`

 #统计已使用的大小（转换单位G）
 used=`free -m |awk '{if(NR==2) printf "%.1f",($2-$NF)/1024}'`

 #统计可使用的大小（转换单位G）
 available=`free -m |awk '{if(NR==2) printf "%.1f",$NF/1024}'`

 #输出内存的总大小和使用率
 echo "内存 - 总大小: ${total}G , 使用: ${used}G , 剩余: ${available}G"
}

#声明磁盘监控函数
function disk(){
 #使用awk命令用/dev作为分隔符统计第一列的信息
 fs=$(df -h |awk '/^\/dev/{print $1}')
    #循环遍历分别统计每个挂载点的磁盘使用率
    for p in $fs; do
        #获取硬盘的挂载点
        mounted=$(df -h |awk '$1=="'$p'"{print $NF}')
        #获取磁盘的大小
        size=$(df -h |awk '$1=="'$p'"{print $2}')
        #获取已用磁盘空间
        used=$(df -h |awk '$1=="'$p'"{print $3}')
        #获取磁盘使用率
        used_percent=$(df -h |awk '$1=="'$p'"{print $5}')
        #输出磁盘使用信息
        echo "硬盘 - 挂载点: $mounted , 总大小: $size , 使用: $used , 使用率: $used_percent"
    done
 
}

#声明tcp信息函数
function tcp_status() {
    #变量summary存放ss命令统计的socket信息，并用awk过滤所有状态的tcp信息
    summary=$(ss -antp |awk '{status[$1]++}END{for(i in status) printf i":"status[i]" "}')

    #输出tcp信息
    echo "TCP连接状态 - $summary"
}

#执行所有函数
cpu
memory
disk
tcp_status
