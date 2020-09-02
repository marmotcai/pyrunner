#!/bin/bash

docker ps -a | grep "Exited" | awk '{print $1 }' | xargs docker rm -f

docker ps -a | grep "Created" | awk '{print $1 }' | xargs docker rm -f

docker images | grep none | awk  '{print $3 }' | xargs docker rmi -f

docker_name=${1}
if [ ! "${docker_name}" ]; then
  echo "带上要删除的特征字符会删除更多，慎重！"
  exit 0
fi

docker ps -a | grep ${docker_name} | awk '{print $1 }' | xargs docker rm -f

docker images | grep ${docker_name} | awk '{print $3}' | xargs docker rmi -f