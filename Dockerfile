# FROM python:alpine AS base
FROM python:stretch AS base

LABEL maintainer="marmotcai@163.com"

ARG ROOT_DIR="/root"

ENV DATA_DIR="${ROOT_DIR}/data"
ENV APP_DIR="${ROOT_DIR}/app"

RUN echo 'ROOT_DIR: ' $APP_DIR

# 创建目录
RUN mkdir -p ${ROOT_DIR} && echo 'ROOT_DIR: ' ${ROOT_DIR}
RUN mkdir -p ${DATA_DIR} && echo 'DATA_DIR: ' ${DATA_DIR}
RUN mkdir -p ${APP_DIR} && echo 'APP_DIR: ' ${APP_DIR}

RUN sed -i '$a\alias ll=\"ls -alF\"' ~/.bashrc
RUN sed -i '$a\alias la=\"ls -A\"' ~/.bashrc
RUN sed -i '$a\alias l=\"ls -CF\"' ~/.bashrc

####################################################################################
# 更新

RUN uname -a
RUN cat /etc/issue

# 更换国内源
RUN rm -f /etc/apt/sources.list
RUN touch /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/debian/ stretch main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/debian/ stretch-backports main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian/ stretch main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian/ stretch-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian/ stretch-backports main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib" >> /etc/apt/sources.list

# 换源后更新
RUN apt-get -y update

# pip更新
ENV PIP_MIRRORS_URL="https://mirrors.aliyun.com/pypi/simple"
RUN python -m pip install -i ${PIP_MIRRORS_URL} --upgrade pip
# 打印版本
RUN pip --version
RUN python --version

####################################################################################
# 构建应用
FROM base as pyrunner
LABEL maintainer="marmotcai@163.com"

ARG GIT_URL=""
ARG RUN_SUBDIR=""
ARG EXPOSE_PORT=0
ARG CMD1="start.sh"
ARG CMD2="web"
ARG CMD3=""

RUN echo 'GIT_URL: ' ${GIT_URL}

# 默认工作路径为APP路径
WORKDIR ${APP_DIR}

RUN if [ "$GIT_URL" = "" ] ; then \
    echo 'GIT_URL is NULL' \
    ; else \
    echo 'GIT_URL is' ${GIT_URL} && \
    git clone ${GIT_URL} ${APP_DIR}/ \
; fi

ENV WORK_DIR=${APP_DIR}/${RUN_SUBDIR}
RUN echo "work dir: " ${WORK_DIR}
WORKDIR ${WORK_DIR}
RUN ls -l

EXPOSE ${EXPOSE_PORT}
RUN echo "EXPOSE_PORT: " ${EXPOSE_PORT}

CMD [${CMD1},${CMD2},${CMD3}] 

#######################################################

