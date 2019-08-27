#!/bin/bash

APP_NAME=qas
APP_GITURL="https://github.com/tp-yan/WebStockPredict.git"

cmd=${1}
param=${2}
param1=${3}

case $cmd in
  image)
    if [ -z "${param1}" ];then
      param1=${APP_GITURL}
    fi

    if [ ! -z "${param}" ];then
      docker build --build-arg APP_GITURL=${param1} --target ${param} -t marmotcai/${param} -f ./Dockerfile .
    else
      docker build --build-arg APP_GITURL=${param1} -t marmotcai/${APP_NAME} -f ./Dockerfile .
    fi 
  ;;

  run)
    docker rm -f my-${APP_NAME}
    if [[ $param =~ 'ssh' ]]; then
      docker run --name my-${APP_NAME} -d -p 3222:22 -v $PWD:/root/app marmotcai/${APP_NAME}
    else
      docker run --name my-${APP_NAME} -d -v $PWD:/root/app marmotcai/${APP_NAME}
    fi
  ;;

  exec)
    if [ -z "${param}" ];then
      docker exec -it my-${APP_NAME} /bin/bash
    else
      docker exec -it ${param} /bin/bash
    fi
  ;;

  bash)
    docker run --rm -ti -v $PWD:/root/app marmotcai/${APP_NAME} /bin/bash
  ;;

  python)
    docker run --rm -ti -v $PWD:/root/app marmotcai/shorttrading python3 /root/app/${param} ${param1}
  ;; 

  *)
    echo "use: sh build.sh image runner https://github.com/marmotcai/qas.git"
    echo "     sh build.sh image"
    echo "use: sh build.sh run --ssh"
    echo "use: sh build.sh exec imagename"
    echo "     sh build.sh bash"
    echo "use: sh build.sh python training.py -v"
  ;;
esac

exit 0;

# docker rm -f my-shorttrading
# docker run --name my-shorttrading -ti -d -p 3222:22 -v $PWD:/root/shorttrading marmotcai/shorttrading
