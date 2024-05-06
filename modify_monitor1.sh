#!/bin/bash

#author: jiahao
#date: 2024-04-10
#version: v1

#监视路径
monitor_dir="/home/workspace/shell"

#日志输出路径
log_file="/tmp/log.txt"

#监视文件变更并输出到日志文件
inotifywait -m -e modify,create,delete,move "$monitor_dir" | while read -r directory event file
do
  #获取当前日期
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  #输出变更到日志文件
  echo "[$timestamp] $event: $directory/$file" >> "$log_file"
done
