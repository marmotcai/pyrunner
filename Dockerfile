FROM python:3 AS base

ARG REQUIREMENTS_URL="NULL"

MAINTAINER marmotcai "marmotcai@163.com"

#######################################################

RUN sed -i '$a\alias ll=\"ls -alF\"' ~/.bashrc
RUN sed -i '$a\alias la=\"ls -A\"' ~/.bashrc
RUN sed -i '$a\alias l=\"ls -CF\"' ~/.bashrc

RUN apt-get update && \
    apt-get install -y wget vim openssh-server && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "root:112233" | chpasswd && \
    mkdir /var/run/sshd

#######################################################

ENV WORK_DIR=/root
WORKDIR ${WORK_DIR}

RUN pip install --upgrade pip

# ENV PIP_INDEX_URL="https://mirrors.aliyun.com/pypi/simple"
# RUN pip install --upgrade -i ${PIP_INDEX_URL} pip

RUN echo ${REQUIREMENTS_URL}i
RUN if [ "${REQUIREMENTS_URL}" != "NULL" ] ; then wget -O requirements.txt ${REQUIREMENTS_URL} ; \
						  # pip install -i ${PIP_INDEX_URL} --no-cache-dir -r requirements.txt ; \
						  pip install --no-cache-dir -r requirements.txt ; \
						  fi

#######################################################

EXPOSE 22
EXPOSE 80

CMD ["/usr/sbin/sshd", "-D"]

#######################################################

