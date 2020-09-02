#!/bin/bash

APP_NAME=pyrunner
APP_GITURL="https://github.com/marmotcai/pyrunner.git"

cmd=${1}
param=${2}
param1=${3}

case $cmd in
  base)
    docker build --build-arg ROOT_DIR=/workspaces --target base -t atoml/base -f ./Dockerfile .
  ;;

  pyrunner)
    GIT_URL=${param}
    if [ -z "${GIT_URL}" ];then
      GIT_URL=${APP_GITURL}
    fi
    echo ${GIT_URL}
    docker build \
          --build-arg ROOT_DIR=/workspaces \
          --build-arg GIT_URL=${GIT_URL} \
          --build-arg GIT_URL=${GIT_URL} \
          --build-arg GIT_URL=${GIT_URL} \
          --build-arg GIT_URL=${GIT_URL} \
          --target pyrunner \
          -t atoml/pyrunner -f ./Dockerfile .
  ;;

  exec)
    if [ -z "${param}" ];then
      docker exec -it my-${APP_NAME} /bin/bash
    else
      docker exec -it ${param} /bin/bash
    fi
  ;;

  bash)
    docker run --rm -ti -v $PWD:/root/local marmotcai/${APP_NAME} /bin/bash
  ;;

  python)
    docker run --rm -ti -v $PWD:/root/app marmotcai/shorttrading python3 /root/app/${param} ${param1}
  ;; 

  *)
    echo "use: sh build.sh image base"
    echo "use: sh build.sh image runner APP_GITURL=://github.com/marmotcai/pyrunner.git"
    echo "     sh build.sh image"
    echo "use: sh build.sh run --ssh"
    echo "use: sh build.sh exec imagename"
    echo "     sh build.sh bash"
    echo "use: sh build.sh python training.py -v"
  ;;
esac

exit 0;

